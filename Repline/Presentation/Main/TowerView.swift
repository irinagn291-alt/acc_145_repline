import SwiftUI

/// Vertical "climb / elevator" main screen: scroll up through floors-as-sets, "+ Set" raises a
/// new floor from below with an impactful haptic on a personal record.
struct TowerView: View {
    @State private var viewModel: TowerViewModel

    init(dependencies: AppDependencies) {
        _viewModel = State(initialValue: TowerViewModel(
            dependencies: dependencies,
            healthSyncEnabled: { UserDefaults.standard.bool(forKey: SettingsStorageKey.healthSyncEnabled) }
        ))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppColor.background.ignoresSafeArea()

                if viewModel.floors.isEmpty && !viewModel.isLoading {
                    EmptyTowerView(
                        onAddSet: { viewModel.isShowingAddSet = true },
                        onBrowseTemplates: { viewModel.showTemplates() }
                    )
                } else {
                    towerContent
                }

                if let fanfareSet = viewModel.personalRecordFanfare {
                    PersonalRecordFanfareView(workoutSet: fanfareSet)
                        .transition(.scale.combined(with: .opacity))
                        .zIndex(1)
                }
            }
            .navigationTitle("Repline")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.showTemplates(for: viewModel.selectedProgramType)
                    } label: {
                        Label("Workouts", systemImage: "list.bullet.rectangle.fill")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    summitBadge
                }
            }
            .sheet(isPresented: $viewModel.isShowingAddSet) {
                AddSetSheet(
                    readySets: viewModel.readySets,
                    onSave: { exercise, weight, reps in
                        Task { await viewModel.logSet(exerciseName: exercise, weight: weight, reps: reps) }
                    }
                )
            }
            .sheet(isPresented: $viewModel.isShowingTemplates) {
                WorkoutTemplatesSheet(
                    templates: viewModel.availableTemplates,
                    programType: viewModel.templateFilterProgramType,
                    onLogSet: { set in
                        Task { await viewModel.logReadySet(set) }
                    },
                    onLogTemplate: { template in
                        Task { await viewModel.logTemplate(template) }
                    }
                )
            }
            .task { await viewModel.load() }
            .animation(.spring(response: 0.4, dampingFraction: 0.75), value: viewModel.personalRecordFanfare)
        }
    }

    private var towerContent: some View {
        VStack(spacing: 0) {
            ProgramTemplatePickerView(selectedProgramType: $viewModel.selectedProgramType, onPick: { program in
                viewModel.showTemplates(for: program)
            })
            .padding(.top, 12)

            if !viewModel.readySets.isEmpty {
                ReadySetsRow(sets: viewModel.readySets) { set in
                    Task { await viewModel.logReadySet(set) }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }

            if let goal = viewModel.dailyGoal {
                DailyFloorGoalCard(goal: goal)
                    .padding(.top, 12)
            }

            if let remaining = viewModel.restSecondsRemaining {
                RestTimerBannerView(secondsRemaining: remaining, onSkip: viewModel.cancelRestTimer)
                    .padding(.top, 12)
            }

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.floors) { floor in
                            FloorBlockView(workoutSet: floor)
                                .id(floor.id)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .padding(16)
                }
                .onChange(of: viewModel.floors.first?.id) { _, newID in
                    guard let newID else { return }
                    withAnimation {
                        proxy.scrollTo(newID, anchor: .top)
                    }
                }
            }

            Button {
                viewModel.isShowingAddSet = true
            } label: {
                Text("Add Set")
            }
            .buttonStyle(ClayButtonStyle())
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
    }

    private var summitBadge: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text("\(viewModel.towerHeight.floors) floors")
                .font(.system(.caption, design: .rounded, weight: .bold))
                .foregroundStyle(AppColor.text)
            Text("\(Int(viewModel.towerHeight.meters)) m")
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(AppColor.text.opacity(0.55))
        }
    }
}

#Preview {
    TowerView(dependencies: PreviewSupport.dependencies)
}

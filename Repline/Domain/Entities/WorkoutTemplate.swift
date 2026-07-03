import Foundation

/// A single preset set with exercise, weight, and reps.
struct TemplateSet: Identifiable, Equatable, Sendable {
    let id: UUID
    let exerciseName: String
    let weight: Double
    let reps: Int

    init(id: UUID = UUID(), exerciseName: String, weight: Double, reps: Int) {
        self.id = id
        self.exerciseName = exerciseName
        self.weight = weight
        self.reps = reps
    }

    var tonnage: Double { weight * Double(reps) }

    var label: String {
        let w = weight.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(weight)) : String(format: "%.1f", weight)
        return "\(exerciseName) · \(w) kg × \(reps)"
    }
}

/// A full ready-made workout: name + ordered preset sets.
struct WorkoutTemplate: Identifiable, Equatable, Sendable {
    let id: String
    let name: String
    let subtitle: String
    let programType: ProgramType
    let sets: [TemplateSet]

    var totalTonnage: Double { sets.reduce(0) { $0 + $1.tonnage } }
    var setCount: Int { sets.count }
}

/// Static catalog of workout templates scaled to the user's experience level.
enum WorkoutTemplateCatalog {
    static func templates(for programType: ProgramType, experience: ExperienceLevel) -> [WorkoutTemplate] {
        baseTemplates
            .filter { $0.programType == programType }
            .map { scale($0, experience: experience) }
    }

    static func allTemplates(experience: ExperienceLevel) -> [WorkoutTemplate] {
        baseTemplates.map { scale($0, experience: experience) }
    }

    static func quickSets(for programType: ProgramType, experience: ExperienceLevel) -> [TemplateSet] {
        templates(for: programType, experience: experience)
            .flatMap(\.sets)
            .uniqued(by: \.exerciseName)
    }

    private static let baseTemplates: [WorkoutTemplate] = [
        WorkoutTemplate(
            id: "push-classic",
            name: "Classic Push",
            subtitle: "Balanced chest, shoulders & triceps",
            programType: .push,
            sets: [
                TemplateSet(exerciseName: "Bench Press", weight: 60, reps: 8),
                TemplateSet(exerciseName: "Bench Press", weight: 60, reps: 8),
                TemplateSet(exerciseName: "Bench Press", weight: 60, reps: 8),
                TemplateSet(exerciseName: "Incline Dumbbell Press", weight: 22, reps: 10),
                TemplateSet(exerciseName: "Incline Dumbbell Press", weight: 22, reps: 10),
                TemplateSet(exerciseName: "Incline Dumbbell Press", weight: 22, reps: 10),
                TemplateSet(exerciseName: "Dumbbell Shoulder Press", weight: 18, reps: 10),
                TemplateSet(exerciseName: "Dumbbell Shoulder Press", weight: 18, reps: 10),
                TemplateSet(exerciseName: "Dumbbell Shoulder Press", weight: 18, reps: 10),
                TemplateSet(exerciseName: "Lateral Raise", weight: 8, reps: 15),
                TemplateSet(exerciseName: "Lateral Raise", weight: 8, reps: 15),
                TemplateSet(exerciseName: "Tricep Pushdown", weight: 25, reps: 12),
                TemplateSet(exerciseName: "Tricep Pushdown", weight: 25, reps: 12),
                TemplateSet(exerciseName: "Tricep Pushdown", weight: 25, reps: 12),
            ]
        ),
        WorkoutTemplate(
            id: "push-strength",
            name: "Strength Push",
            subtitle: "Heavy compounds, low reps",
            programType: .push,
            sets: [
                TemplateSet(exerciseName: "Bench Press", weight: 80, reps: 5),
                TemplateSet(exerciseName: "Bench Press", weight: 80, reps: 5),
                TemplateSet(exerciseName: "Bench Press", weight: 80, reps: 5),
                TemplateSet(exerciseName: "Overhead Press", weight: 50, reps: 5),
                TemplateSet(exerciseName: "Overhead Press", weight: 50, reps: 5),
                TemplateSet(exerciseName: "Overhead Press", weight: 50, reps: 5),
                TemplateSet(exerciseName: "Dips", weight: 70, reps: 8),
                TemplateSet(exerciseName: "Dips", weight: 70, reps: 8),
                TemplateSet(exerciseName: "Dips", weight: 70, reps: 8),
            ]
        ),
        WorkoutTemplate(
            id: "push-quick",
            name: "Quick Push",
            subtitle: "30-min session, 3 exercises",
            programType: .push,
            sets: [
                TemplateSet(exerciseName: "Bench Press", weight: 55, reps: 10),
                TemplateSet(exerciseName: "Bench Press", weight: 55, reps: 10),
                TemplateSet(exerciseName: "Bench Press", weight: 55, reps: 10),
                TemplateSet(exerciseName: "Dumbbell Shoulder Press", weight: 16, reps: 10),
                TemplateSet(exerciseName: "Dumbbell Shoulder Press", weight: 16, reps: 10),
                TemplateSet(exerciseName: "Dumbbell Shoulder Press", weight: 16, reps: 10),
                TemplateSet(exerciseName: "Tricep Pushdown", weight: 20, reps: 12),
                TemplateSet(exerciseName: "Tricep Pushdown", weight: 20, reps: 12),
                TemplateSet(exerciseName: "Tricep Pushdown", weight: 20, reps: 12),
            ]
        ),
        WorkoutTemplate(
            id: "pull-classic",
            name: "Classic Pull",
            subtitle: "Back thickness & biceps",
            programType: .pull,
            sets: [
                TemplateSet(exerciseName: "Barbell Row", weight: 60, reps: 8),
                TemplateSet(exerciseName: "Barbell Row", weight: 60, reps: 8),
                TemplateSet(exerciseName: "Barbell Row", weight: 60, reps: 8),
                TemplateSet(exerciseName: "Lat Pulldown", weight: 50, reps: 10),
                TemplateSet(exerciseName: "Lat Pulldown", weight: 50, reps: 10),
                TemplateSet(exerciseName: "Lat Pulldown", weight: 50, reps: 10),
                TemplateSet(exerciseName: "Seated Cable Row", weight: 45, reps: 10),
                TemplateSet(exerciseName: "Seated Cable Row", weight: 45, reps: 10),
                TemplateSet(exerciseName: "Seated Cable Row", weight: 45, reps: 10),
                TemplateSet(exerciseName: "Face Pull", weight: 15, reps: 15),
                TemplateSet(exerciseName: "Face Pull", weight: 15, reps: 15),
                TemplateSet(exerciseName: "Bicep Curl", weight: 14, reps: 12),
                TemplateSet(exerciseName: "Bicep Curl", weight: 14, reps: 12),
                TemplateSet(exerciseName: "Bicep Curl", weight: 14, reps: 12),
            ]
        ),
        WorkoutTemplate(
            id: "pull-strength",
            name: "Strength Pull",
            subtitle: "Heavy rows & deadlift",
            programType: .pull,
            sets: [
                TemplateSet(exerciseName: "Deadlift", weight: 100, reps: 5),
                TemplateSet(exerciseName: "Deadlift", weight: 100, reps: 5),
                TemplateSet(exerciseName: "Deadlift", weight: 100, reps: 5),
                TemplateSet(exerciseName: "Barbell Row", weight: 70, reps: 5),
                TemplateSet(exerciseName: "Barbell Row", weight: 70, reps: 5),
                TemplateSet(exerciseName: "Barbell Row", weight: 70, reps: 5),
                TemplateSet(exerciseName: "Pull-Up", weight: 70, reps: 6),
                TemplateSet(exerciseName: "Pull-Up", weight: 70, reps: 6),
                TemplateSet(exerciseName: "Pull-Up", weight: 70, reps: 6),
            ]
        ),
        WorkoutTemplate(
            id: "pull-quick",
            name: "Quick Pull",
            subtitle: "Fast back & arms",
            programType: .pull,
            sets: [
                TemplateSet(exerciseName: "Lat Pulldown", weight: 45, reps: 10),
                TemplateSet(exerciseName: "Lat Pulldown", weight: 45, reps: 10),
                TemplateSet(exerciseName: "Lat Pulldown", weight: 45, reps: 10),
                TemplateSet(exerciseName: "Barbell Row", weight: 50, reps: 10),
                TemplateSet(exerciseName: "Barbell Row", weight: 50, reps: 10),
                TemplateSet(exerciseName: "Barbell Row", weight: 50, reps: 10),
                TemplateSet(exerciseName: "Bicep Curl", weight: 12, reps: 12),
                TemplateSet(exerciseName: "Bicep Curl", weight: 12, reps: 12),
                TemplateSet(exerciseName: "Bicep Curl", weight: 12, reps: 12),
            ]
        ),
        WorkoutTemplate(
            id: "legs-classic",
            name: "Classic Legs",
            subtitle: "Squat-focused leg day",
            programType: .legs,
            sets: [
                TemplateSet(exerciseName: "Barbell Squat", weight: 80, reps: 8),
                TemplateSet(exerciseName: "Barbell Squat", weight: 80, reps: 8),
                TemplateSet(exerciseName: "Barbell Squat", weight: 80, reps: 8),
                TemplateSet(exerciseName: "Romanian Deadlift", weight: 60, reps: 10),
                TemplateSet(exerciseName: "Romanian Deadlift", weight: 60, reps: 10),
                TemplateSet(exerciseName: "Romanian Deadlift", weight: 60, reps: 10),
                TemplateSet(exerciseName: "Leg Press", weight: 120, reps: 12),
                TemplateSet(exerciseName: "Leg Press", weight: 120, reps: 12),
                TemplateSet(exerciseName: "Leg Press", weight: 120, reps: 12),
                TemplateSet(exerciseName: "Leg Curl", weight: 35, reps: 12),
                TemplateSet(exerciseName: "Leg Curl", weight: 35, reps: 12),
                TemplateSet(exerciseName: "Leg Curl", weight: 35, reps: 12),
                TemplateSet(exerciseName: "Calf Raise", weight: 60, reps: 15),
                TemplateSet(exerciseName: "Calf Raise", weight: 60, reps: 15),
                TemplateSet(exerciseName: "Calf Raise", weight: 60, reps: 15),
            ]
        ),
        WorkoutTemplate(
            id: "legs-strength",
            name: "Strength Legs",
            subtitle: "Heavy squats & deadlifts",
            programType: .legs,
            sets: [
                TemplateSet(exerciseName: "Barbell Squat", weight: 100, reps: 5),
                TemplateSet(exerciseName: "Barbell Squat", weight: 100, reps: 5),
                TemplateSet(exerciseName: "Barbell Squat", weight: 100, reps: 5),
                TemplateSet(exerciseName: "Romanian Deadlift", weight: 80, reps: 5),
                TemplateSet(exerciseName: "Romanian Deadlift", weight: 80, reps: 5),
                TemplateSet(exerciseName: "Romanian Deadlift", weight: 80, reps: 5),
                TemplateSet(exerciseName: "Walking Lunge", weight: 20, reps: 10),
                TemplateSet(exerciseName: "Walking Lunge", weight: 20, reps: 10),
                TemplateSet(exerciseName: "Walking Lunge", weight: 20, reps: 10),
            ]
        ),
        WorkoutTemplate(
            id: "legs-quick",
            name: "Quick Legs",
            subtitle: "Efficient lower body",
            programType: .legs,
            sets: [
                TemplateSet(exerciseName: "Barbell Squat", weight: 70, reps: 10),
                TemplateSet(exerciseName: "Barbell Squat", weight: 70, reps: 10),
                TemplateSet(exerciseName: "Barbell Squat", weight: 70, reps: 10),
                TemplateSet(exerciseName: "Leg Press", weight: 100, reps: 12),
                TemplateSet(exerciseName: "Leg Press", weight: 100, reps: 12),
                TemplateSet(exerciseName: "Leg Press", weight: 100, reps: 12),
                TemplateSet(exerciseName: "Calf Raise", weight: 50, reps: 15),
                TemplateSet(exerciseName: "Calf Raise", weight: 50, reps: 15),
                TemplateSet(exerciseName: "Calf Raise", weight: 50, reps: 15),
            ]
        ),
    ]

    private static func scale(_ template: WorkoutTemplate, experience: ExperienceLevel) -> WorkoutTemplate {
        let multiplier: Double = switch experience {
        case .beginner: 0.75
        case .intermediate: 1.0
        case .advanced: 1.25
        }

        let scaledSets = template.sets.map { set in
            TemplateSet(
                id: set.id,
                exerciseName: set.exerciseName,
                weight: roundWeight(set.weight * multiplier),
                reps: set.reps
            )
        }

        return WorkoutTemplate(
            id: template.id,
            name: template.name,
            subtitle: template.subtitle,
            programType: template.programType,
            sets: scaledSets
        )
    }

    private static func roundWeight(_ value: Double) -> Double {
        guard value > 0 else { return 0 }
        return (value * 2).rounded() / 2
    }
}

private extension Array {
    func uniqued<ID: Hashable>(by keyPath: KeyPath<Element, ID>) -> [Element] {
        var seen = Set<ID>()
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
}

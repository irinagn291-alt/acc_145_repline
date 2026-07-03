import Foundation
import SwiftData

/// In-memory dependencies for SwiftUI `#Preview` use only.
@MainActor
enum PreviewSupport {
    static let dependencies: AppDependencies = {
        let schema = Schema(AppSchema.allModels)
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])
            return AppDependencies(modelContext: container.mainContext)
        } catch {
            fatalError("Could not create preview ModelContainer: \(error)")
        }
    }()
}

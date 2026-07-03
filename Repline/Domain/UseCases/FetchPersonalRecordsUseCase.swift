import Foundation

/// Fetches every personal record, most recently achieved first.
protocol FetchPersonalRecordsUseCase {
    func execute() async throws -> [PersonalRecord]
}

final class DefaultFetchPersonalRecordsUseCase: FetchPersonalRecordsUseCase {
    private let personalRecords: PersonalRecordRepository

    init(personalRecords: PersonalRecordRepository) {
        self.personalRecords = personalRecords
    }

    func execute() async throws -> [PersonalRecord] {
        try await personalRecords.fetchAll().sorted { $0.achievedDate > $1.achievedDate }
    }
}

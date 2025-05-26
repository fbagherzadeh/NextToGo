//
//  NextToGoViewModel.swift
//  NextToGo
//
//  Created by Farhad Bagherzadeh on 25/5/2025.
//

import Foundation

class NextToGoViewModel: ObservableObject {
  @Published var viewState: NextToGoViewState = .loading
  private(set) var selectedFilter: FilterType = .all

  private var sortedRaceSummary: [RaceSummary] = []
  private let racingService: RacingServiceProtocol

  init(racingService: RacingServiceProtocol = RacingService()) {
    self.racingService = racingService
  }

  @MainActor
  func loadRaces() {
    viewState = .loading
    Task {
      do {
        sortedRaceSummary = try await fetchAndSortRaceSummary()
        updateLoadedState()
      } catch {
        viewState = .somethingWentWrong
      }
    }
  }

  @MainActor
  func removeRace(_ raceID: String) {
    sortedRaceSummary.removeAll(where: { $0.raceID == raceID })
    if sortedRaceSummary.count < 7 {
      Task {
        sortedRaceSummary = (try? await fetchAndSortRaceSummary()) ?? []
      }
    }
    updateLoadedState(with: selectedFilter)
  }

  func updateLoadedState(with filter: FilterType = .all) {
    selectedFilter = filter
    var first5 = sortedRaceSummary.count > 5 ? Array(sortedRaceSummary.prefix(upTo: 5)) : sortedRaceSummary
    if let catId = filter.categoryId {
      first5 = first5.filter({ $0.categoryID == catId })
    }
    viewState = first5.isEmpty ? .empty : .loaded(races: first5)
  }

  private func fetchAndSortRaceSummary() async throws -> [RaceSummary] {
    let races = try await racingService.fetchRacing()
    return races.data.raceSummaries.values.sorted(by: { $0.raceStartDate < $1.raceStartDate })
  }
}

enum NextToGoViewState {
  case loading
  case empty
  case somethingWentWrong
  case loaded(races: [RaceSummary])
}

enum FilterType: String, CaseIterable {
  case all
  case greyhound
  case horse
  case harness

  var categoryId: String? {
    switch self {
    case .all: nil
    case .greyhound: "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
    case .horse: "4a2788f8-e825-4d36-9894-efd4baf1cfae"
    case .harness: "161d9be2-e909-4326-8c2c-35ed71fb460b"
    }
  }
}

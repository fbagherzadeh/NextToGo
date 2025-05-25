//
//  NextToGoViewModel.swift
//  NextToGo
//
//  Created by Farhad Bagherzadeh on 25/5/2025.
//

import Foundation

class NextToGoViewModel: ObservableObject {
  @Published var viewState: NextToGoViewState = .loading
  @Published var selectedFilter: FilterType = .all

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
        let races = try await racingService.fetchRacing()
        sortedRaceSummary = races.data.raceSummaries.values.sorted(by: { $0.raceStartDate < $1.raceStartDate })
        let first5 = Array(sortedRaceSummary.prefix(upTo: 5))
        viewState = races.data.nextToGoIDs.isEmpty ? .empty : .loaded(races: first5)
      } catch {
        viewState = .somethingWentWrong
      }
    }
  }

  func removeRace(_ raceID: String) {
    sortedRaceSummary.removeAll(where: { $0.raceID == raceID })
    // TODO: check the number and load extra silently
    let first5 = Array(sortedRaceSummary.prefix(upTo: 5))
    viewState = .loaded(races: first5)
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
}

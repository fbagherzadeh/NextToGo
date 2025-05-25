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

  private let racingService: RacingServiceProtocol

  init(racingService: RacingServiceProtocol = RacingService()) {
    self.racingService = racingService
  }

  @MainActor
  func loadRaces() {
    viewState = .loading
    Task {
      do {
        let a = try await racingService.fetchRacing()
        viewState = a.data.nextToGoIDs.isEmpty ? .empty : .loaded
      } catch {
        viewState = .somethingWentWrong
      }
    }
  }
}

enum NextToGoViewState {
  case loading
  case empty
  case somethingWentWrong
  case loaded
}

enum FilterType: String, CaseIterable {
  case all
  case greyhound
  case horse
  case harness
}

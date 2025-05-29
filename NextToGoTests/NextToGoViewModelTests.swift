//
//  NextToGoViewModelTests.swift
//  NextToGoTests
//
//  Created by Farhad Bagherzadeh on 27/5/2025.
//

import Testing
import Combine
@testable import NextToGo

@MainActor
class NextToGoViewModelTests {
  let viewModel: NextToGoViewModel!
  let mockRacingService: MockRacingService!
  var cancellable: [AnyCancellable] = []
  
  init() {
    mockRacingService = .init()
    viewModel = .init(racingService: mockRacingService)
  }
  
  @Test func initialisation() async throws {
    #expect(viewModel.viewState == .loading)
    #expect(viewModel.selectedFilter == .all)
  }
  
  @Test("Testing loadRaces with success scenario")
  func loadRaces_withSuccess() async throws {
    await viewModel.loadRaces()
    if case let .loaded(races) = viewModel.viewState {
      #expect(races.count == 5)
      #expect(races.map { $0.raceID } == ["raceID4", "raceID7", "raceID10", "raceID8", "raceID6"])
    } else {
      Issue.record("viewState must be loaded")
    }
  }
  
  @Test("Testing both loadRaces with error scenario and when called, viewState must emit loading first")
  func loadRaces_withError() async throws {
    let viewModel = NextToGoViewModel(racingService: MockRacingService(shouldThrows: true))
    await confirmation { confirm in
      viewModel.$viewState
        .dropFirst()
        .sink { state in
          if state == .loading {
            confirm()
          }
        }
        .store(in: &cancellable)
      
      await viewModel.loadRaces()
    }
    
    #expect(viewModel.viewState == .somethingWentWrong)
  }

  @Test() func removeRace() async throws {
    await viewModel.loadRaces()
    viewModel.removeRace("raceID4")
    if case let .loaded(races) = viewModel.viewState {
      #expect(races.count == 5)
      #expect(races.map { $0.raceID } == ["raceID7", "raceID10", "raceID8", "raceID6", "raceID3"])
    } else {
      Issue.record("viewState must be loaded")
    }
  }

  @Test() func removeRace_withSortedRaceSummaryLessThan7() async throws {
    await viewModel.loadRaces()
    await mockRacingService.resetFetchRacingInvocation()
    ["raceID4", "raceID7", "raceID10"].forEach { viewModel.removeRace($0) }
    await confirmation { confirm in
      let fetchMoreTask = viewModel.removeRace("raceID8")// {
      _ = await fetchMoreTask?.result
      confirm()
    }
    #expect(await mockRacingService.didInvokeFetchRacing)
  }

  @Test(
    "updateLoadedState with `all` as filter type and different number of raceSummaries",
    arguments: [
      (
        RaceSummary.Fixture.sortedRaceSummaries,
        NextToGoViewState.loaded(races: Array(RaceSummary.Fixture.sortedRaceSummaries.prefix(5)))
      ),
      (
        Array(RaceSummary.Fixture.sortedRaceSummaries.prefix(3)),
        NextToGoViewState.loaded(races: Array(RaceSummary.Fixture.sortedRaceSummaries.prefix(3)))
      ),
      (
        [],
        NextToGoViewState.empty
      )
    ]
  )
  func updateLoadedState(raceSummaries: [RaceSummary], expectedViewState: NextToGoViewState) async throws {
    let viewModel = NextToGoViewModel(racingService: MockRacingService(raceSummaries: raceSummaries))
    await viewModel.loadRaces()
    viewModel.updateLoadedState()
    #expect(viewModel.viewState == expectedViewState)
  }

  @Test(
    "updateLoadedState with different filter types",
    arguments: [
      (
        FilterType.all,
        5,
        ["raceID4", "raceID7", "raceID10", "raceID8", "raceID6"]
      ),
      (
        FilterType.greyhound,
        2,
        ["raceID8", "raceID6"]
      ),
      (
        FilterType.harness,
        2,
        ["raceID4", "raceID7"]
      ),
      (
        FilterType.horse,
        1,
        ["raceID10"]
      )
    ]
  )
  func updateLoadedState(
    filterType: FilterType,
    expectedRacesCount: Int,
    expectedRaceIds: [String]
  ) async throws {
    let viewModel = NextToGoViewModel(racingService: MockRacingService(raceSummaries: RaceSummary.Fixture.sortedRaceSummaries))
    await viewModel.loadRaces()
    viewModel.updateLoadedState(with: filterType)

    if case let .loaded(races) = viewModel.viewState {
      #expect(races.count == expectedRacesCount)
      #expect(races.map { $0.raceID } == expectedRaceIds)
    } else {
      Issue.record("viewState must be loaded")
    }
  }
}

extension NextToGoViewState: @retroactive Equatable {
  public static func == (lhs: NextToGoViewState, rhs: NextToGoViewState) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading),
      (.empty, .empty),
      (.somethingWentWrong, .somethingWentWrong):
      true
    case let (.loaded(lhsRaces), .loaded(rhsRaces)):
      lhsRaces == rhsRaces
    default:
      false
    }
  }
}

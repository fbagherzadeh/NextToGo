//
//  NextToGoViewModelTests.swift
//  NextToGoTests
//
//  Created by Farhad Bagherzadeh on 27/5/2025.
//

import Testing
@testable import NextToGo

@MainActor
struct NextToGoViewModelTests {
  let mockRacingService: MockRacingService = .init()

  @Test func initialisation() async throws {
    let viewModel = NextToGoViewModel(racingService: mockRacingService)
    #expect(viewModel.viewState == .loading)
    #expect(viewModel.selectedFilter == .all)
  }

  @Test func loadRaces_withSuccess() async throws {
    let viewModel = NextToGoViewModel(racingService: mockRacingService)
    await viewModel.loadRaces()
    if case let .loaded(races) = viewModel.viewState {
      #expect(races.count == 5)
    } else {
      Issue.record("viewState must be loaded")
    }
  }

  /// Not a clean/easy way to check `viewState = .loading`
  @Test func loadRaces_withError() async throws {
    let viewModel = NextToGoViewModel(racingService: MockRacingService(shouldThrows: true))
    await viewModel.loadRaces()
    #expect(viewModel.viewState == .somethingWentWrong)
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

func withThrowingTimeout<T>(
  seconds: Duration,
  operation: @escaping () async throws -> T
) async throws -> T {
  try await withThrowingTaskGroup(of: T.self) { group in
    group.addTask {
      try await operation()
    }

    group.addTask {
      try await Task.sleep(for: seconds)
      throw CancellationError()
    }

    let result = try await group.next()!
    group.cancelAll()
    return result
  }
}

func withTimeLimit(
  _ timeLimit: Duration,
  _ body: @escaping @Sendable () async throws -> Void,
  timeoutHandler: @escaping @Sendable () -> Void
) async throws {
  try await withThrowingTaskGroup(of: Void.self) { group in
    group.addTask {
      // If sleep() returns instead of throwing a CancellationError, that means
      // the timeout was reached before this task could be cancelled, so call
      // the timeout handler.
      try await SuspendingClock().sleep(for: timeLimit)
      timeoutHandler()
    }
    group.addTask(operation: body)

    defer {
      group.cancelAll()
    }
    try await group.next()!
  }
}

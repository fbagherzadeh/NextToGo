//
//  RaceRowViewModelTests.swift
//  NextToGoTests
//
//  Created by Farhad Bagherzadeh on 24/5/2025.
//

import Testing
import Foundation
@testable import NextToGo

struct RaceRowViewModelTests {
  @Test func initialisation() async throws {
    let race: RaceSummary = .makeTestInstance()
    let raceRowViewModel = RaceRowViewModel(
      race: race,
      pastOneMinuteAction: {}
    )
    #expect(raceRowViewModel.remainingTime == "")
    #expect(!raceRowViewModel.isRunningOutOfTime)
    #expect(raceRowViewModel.race == race)
  }

  @Test(
    "When updateRemainingTime being called, isRunningOutOfTime should have correct value",
    arguments: [
      (Date.now.addingTimeInterval(120), false),
      (Date.now.addingTimeInterval(40), true)
    ]
  )
  func updateRemainingTime_isRunningOutOfTime(date: Date, expectedResult: Bool) async throws {
    let raceRowViewModel = RaceRowViewModel(
      race: .makeTestInstance(raceStartDate: date),
      pastOneMinuteAction: {}
    )
    raceRowViewModel.updateRemainingTime()
    #expect(raceRowViewModel.isRunningOutOfTime == expectedResult)
  }

  @Test(
    "When updateRemainingTime being called, remainingTime should have correct value",
    arguments: [
      /// Expecting one sec less as we are rounding down the TimeInterval within the viewModel's updateRemainingTime
      (Date.now.addingTimeInterval(913), "15m 12s"),
      (Date.now.addingTimeInterval(63), "1m 2s"),
      (Date.now.addingTimeInterval(43), "42s"),
      (Date.now.addingTimeInterval(1), "0s"),
      (Date.now.addingTimeInterval(0), "-1s"),
      (Date.now.addingTimeInterval(-30), "-31s"),
    ]
  )
  func updateRemainingTime_remainingTime(date: Date, expectedResult: String) async throws {
    let raceRowViewModel = RaceRowViewModel(
      race: .makeTestInstance(raceStartDate: date),
      pastOneMinuteAction: {}
    )
    raceRowViewModel.updateRemainingTime()
    #expect(raceRowViewModel.remainingTime == expectedResult)
  }

  @Test(
    "When updateRemainingTime being called with remainingTime past one minute, pastOneMinuteAction should be called")
  func updateRemainingTime_remainingTime() async throws {
    var isPastOneMinuteActionCalled: Bool = false
    let raceRowViewModel = RaceRowViewModel(
      race: .makeTestInstance(raceStartDate: Date.now.addingTimeInterval(-60)),
      pastOneMinuteAction: { isPastOneMinuteActionCalled = true }
    )
    raceRowViewModel.updateRemainingTime()
    #expect(isPastOneMinuteActionCalled)
  }
}

extension RaceSummary: @retroactive Equatable {
  static func makeTestInstance(
    raceID: String = "testRaceID",
    raceName: String = "Test Race",
    raceNumber: Int = 1,
    meetingID: String = "testMeetingID",
    meetingName: String = "Test Meeting",
    categoryID: String = "testCategoryID",
    raceStartDate: Date = Date.now
  ) -> RaceSummary {
    return RaceSummary(
      raceID: raceID,
      raceName: raceName,
      raceNumber: raceNumber,
      meetingID: meetingID,
      meetingName: meetingName,
      categoryID: categoryID,
      raceStartDate: raceStartDate
    )
  }

  public static func == (lhs: RaceSummary, rhs: RaceSummary) -> Bool {
    lhs.raceID == rhs.raceID &&
    lhs.raceName == rhs.raceName &&
    lhs.raceNumber == rhs.raceNumber &&
    lhs.meetingID == rhs.meetingID &&
    lhs.meetingName == rhs.meetingName &&
    lhs.categoryID == rhs.categoryID &&
    lhs.raceStartDate == rhs.raceStartDate
  }
}

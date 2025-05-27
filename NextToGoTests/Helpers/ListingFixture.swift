//
//  RaceSummaryFixture.swift
//  NextToGoTests
//
//  Created by Farhad Bagherzadeh on 27/5/2025.
//

import Foundation
@testable import NextToGo

/// greyhound: "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
/// horse: "4a2788f8-e825-4d36-9894-efd4baf1cfae"
/// harness: "161d9be2-e909-4326-8c2c-35ed71fb460b"

extension RaceSummary {
  struct Fixture {
    /// Expected orders marked with comments
    static let unsortedRaceSummaries: [RaceSummary] = [
      .init(
        raceID: "raceID1",
        raceName: "raceName1",
        raceNumber: 1,
        meetingID: "meetingID1",
        meetingName: "meetingName1",
        categoryID: "9daef0d7-bf3c-4f50-921d-8e818c60fe61",
        raceStartDate: .now.addingTimeInterval(121) /// #7
      ),
      .init(
        raceID: "raceID2",
        raceName: "raceName2",
        raceNumber: 2,
        meetingID: "meetingID2",
        meetingName: "meetingName2",
        categoryID: "4a2788f8-e825-4d36-9894-efd4baf1cfae",
        raceStartDate: .now.addingTimeInterval(160) /// #8
      ),
      .init(
        raceID: "raceID3",
        raceName: "raceName3",
        raceNumber: 3,
        meetingID: "meetingID3",
        meetingName: "meetingName3",
        categoryID: "161d9be2-e909-4326-8c2c-35ed71fb460b",
        raceStartDate: .now.addingTimeInterval(119) /// #6
      ),
      .init(
        raceID: "raceID4",
        raceName: "raceName4",
        raceNumber: 4,
        meetingID: "meetingID4",
        meetingName: "meetingName4",
        categoryID: "161d9be2-e909-4326-8c2c-35ed71fb460b",
        raceStartDate: .now.addingTimeInterval(-23) /// #1
      ),
      .init(
        raceID: "raceID5",
        raceName: "raceName5",
        raceNumber: 5,
        meetingID: "meetingID5",
        meetingName: "meetingName5",
        categoryID: "4a2788f8-e825-4d36-9894-efd4baf1cfae",
        raceStartDate: .now.addingTimeInterval(900) /// #9
      ),
      .init(
        raceID: "raceID6",
        raceName: "raceName6",
        raceNumber: 6,
        meetingID: "meetingID6",
        meetingName: "meetingName6",
        categoryID: "9daef0d7-bf3c-4f50-921d-8e818c60fe61",
        raceStartDate: .now.addingTimeInterval(118) /// #5
      ),
      .init(
        raceID: "raceID7",
        raceName: "raceName7",
        raceNumber: 7,
        meetingID: "meetingID7",
        meetingName: "meetingName7",
        categoryID: "161d9be2-e909-4326-8c2c-35ed71fb460b",
        raceStartDate: .now.addingTimeInterval(-13) /// #2
      ),
      .init(
        raceID: "raceID8",
        raceName: "raceName8",
        raceNumber: 8,
        meetingID: "meetingID8",
        meetingName: "meetingName8",
        categoryID: "9daef0d7-bf3c-4f50-921d-8e818c60fe61",
        raceStartDate: .now.addingTimeInterval(46) /// #4
      ),
      .init(
        raceID: "raceID9",
        raceName: "raceName9",
        raceNumber: 9,
        meetingID: "meetingID9",
        meetingName: "meetingName9",
        categoryID: "161d9be2-e909-4326-8c2c-35ed71fb460b",
        raceStartDate: .now.addingTimeInterval(1001) /// #10
      ),
      .init(
        raceID: "raceID10",
        raceName: "raceName10",
        raceNumber: 10,
        meetingID: "meetingID10",
        meetingName: "meetingName10",
        categoryID: "161d9be2-e909-4326-8c2c-35ed71fb460b",
        raceStartDate: .now.addingTimeInterval(-4) /// #3
      ),
    ]
  }
}

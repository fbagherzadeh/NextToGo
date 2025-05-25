//
//  RaceAPIResponse.swift
//  NextToGo
//
//  Created by Farhad Bagherzadeh on 25/5/2025.
//

import Foundation

struct RaceAPIResponse: Codable {
  let status: Int
  let data: RaceData
  let message: String
}

struct RaceData: Codable {
  let nextToGoIDs: [String]
  /// Dictionary with race_id as the key
  let raceSummaries: [String: RaceSummary]

  enum CodingKeys: String, CodingKey {
    case nextToGoIDs = "next_to_go_ids"
    case raceSummaries = "race_summaries"
  }
}

struct RaceSummary: Codable {
  let raceID: String
  let raceName: String
  let raceNumber: Int
  let meetingID: String
  let meetingName: String
  let categoryID: String
  let advertisedStart: AdvertisedStart

  enum CodingKeys: String, CodingKey {
    case raceID = "race_id"
    case raceName = "race_name"
    case raceNumber = "race_number"
    case meetingID = "meeting_id"
    case meetingName = "meeting_name"
    case categoryID = "category_id"
    case advertisedStart = "advertised_start"
  }
}

struct AdvertisedStart: Codable {
  let seconds: Int
}

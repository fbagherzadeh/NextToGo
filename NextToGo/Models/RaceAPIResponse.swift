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
  let raceStartDate: Date

  /// Top-level coding keys
  enum CodingKeys: String, CodingKey {
    case raceID = "race_id"
    case raceName = "race_name"
    case raceNumber = "race_number"
    case meetingID = "meeting_id"
    case meetingName = "meeting_name"
    case categoryID = "category_id"
    case advertisedStart = "advertised_start"
  }

  /// Coding keys for seconds
  enum AdvertisedStartCodingKeys: String, CodingKey {
    case seconds
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    raceID = try container.decode(String.self, forKey: .raceID)
    raceName = try container.decode(String.self, forKey: .raceName)
    raceNumber = try container.decode(Int.self, forKey: .raceNumber)
    meetingID = try container.decode(String.self, forKey: .meetingID)
    meetingName = try container.decode(String.self, forKey: .meetingName)
    categoryID = try container.decode(String.self, forKey: .categoryID)

    // Decode seconds and convert to Date
    let advertisedStartContainer = try container.nestedContainer(keyedBy: AdvertisedStartCodingKeys.self, forKey: .advertisedStart)
    let seconds = try advertisedStartContainer.decode(Int.self, forKey: .seconds)
    raceStartDate = Date(timeIntervalSince1970: TimeInterval(seconds))
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(raceID, forKey: .raceID)
    try container.encode(raceName, forKey: .raceName)
    try container.encode(raceNumber, forKey: .raceNumber)
    try container.encode(meetingID, forKey: .meetingID)
    try container.encode(meetingName, forKey: .meetingName)
    try container.encode(categoryID, forKey: .categoryID)

    // Calculate seconds from raceStartDate for encoding
    let seconds = Int(raceStartDate.timeIntervalSince1970)

    // Create a nested container for advertised_start
    var advertisedStartContainer = container.nestedContainer(keyedBy: AdvertisedStartCodingKeys.self, forKey: .advertisedStart)
    try advertisedStartContainer.encode(seconds, forKey: .seconds)
  }
}

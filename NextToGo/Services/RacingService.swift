//
//  RacingService.swift
//  NextToGo
//
//  Created by Farhad Bagherzadeh on 25/5/2025.
//

import Foundation

protocol RacingServiceProtocol: Sendable {
  func fetchRacing() async throws -> RaceAPIResponse
}

struct RacingService: RacingServiceProtocol {
  private let httpClient: HTTPClientProtocol

  init(httpClient: HTTPClientProtocol = HTTPClient()) {
    self.httpClient = httpClient
  }

  func fetchRacing() async throws -> RaceAPIResponse {
    guard let url = URL(string: "https://api.neds.com.au/rest/v1/racing/") else {
      throw NetworkError.invalidURL
    }

    let queryItem: [URLQueryItem] = [
      .init(name: "method", value: "nextraces"),
      .init(name: "count", value: "10")
    ]
    let resource: Resource<RaceAPIResponse> = .init(
      url: url,
      method: .get(queryItem),
      modelType: RaceAPIResponse.self
    )

    return try await httpClient.load(resource)
  }
}

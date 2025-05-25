//
//  NetworkError.swift
//  NextToGo
//
//  Created by Farhad Bagherzadeh on 25/5/2025.
//

import Foundation

enum NetworkError: Error {
  case invalidURL
  case badRequest
  case decodingError(Error)
  case invalidResponse
  case errorResponse(ErrorResponse)
  case unknown

  var description: String {
    switch self {
    case .invalidURL:
      "Invalid URL."
    case .badRequest:
      "Bad Request (400): Unable to perform the request."
    case .decodingError(let error):
      "Unable to decode successfully - \(error.localizedDescription)."
    case .invalidResponse:
      "Invalid response."
    case .errorResponse(let errorResponse):
      "Error - \(errorResponse.message ?? "")."
    case .unknown:
      "Something went wrong."
    }
  }
}

struct ErrorResponse: Codable {
  let message: String?
}

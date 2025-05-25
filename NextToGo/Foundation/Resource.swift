//
//  Resource.swift
//  NextToGo
//
//  Created by Farhad Bagherzadeh on 25/5/2025.
//

import Foundation

struct Resource<T: Codable> {
  let url: URL
  var method: HTTPMethod = .get([])
  var headers: [String: String]? = nil
  var modelType: T.Type
}

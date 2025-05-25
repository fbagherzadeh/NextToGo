//
//  NoContentView.swift
//  NextToGo
//
//  Created by Farhad Bagherzadeh on 26/5/2025.
//

import SwiftUI

struct NoContentView: View {
  let filterName: String

  init(filterName: String) {
    self.filterName = filterName
  }

  var body: some View {
    ContentUnavailableView(
      "No results for \(filterName)",
      systemImage: "flag.pattern.checkered",
      description: Text("Visit later or try other categories")
    )
  }
}

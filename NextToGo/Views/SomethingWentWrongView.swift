//
//  SomethingWentWrongView.swift
//  NextToGo
//
//  Created by Farhad Bagherzadeh on 26/5/2025.
//

import SwiftUI

struct SomethingWentWrongView: View {
  let retryAction: @MainActor @Sendable () async -> Void

  var body: some View {
    ContentUnavailableView(
      label: { Label("Something went wrong", systemImage: "x.circle") },
      description: { Text("Please try again") },
      actions: { Button("Retry") { Task { await retryAction() } } }
    )
  }
}

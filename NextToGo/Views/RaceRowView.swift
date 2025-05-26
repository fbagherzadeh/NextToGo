//
//  RaceRowView.swift
//  NextToGo
//
//  Created by Farhad Bagherzadeh on 26/5/2025.
//

import SwiftUI

struct RaceRowView: View {
  @StateObject private var viewModel: RaceRowViewModel
  @Environment(\.colorScheme) private var colorScheme
  private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  init(
    race: RaceSummary,
    pastOneMinuteAction: @escaping () -> Void
  ) {
    self._viewModel = .init(
      wrappedValue: .init(
        race: race,
        pastOneMinuteAction: pastOneMinuteAction
      )
    )
  }

  var body: some View {
    HStack {
      if let imageName = viewModel.race.imageName {
        Image(imageName)
          .resizable()
          .frame(width: 40, height: 40)
      }

      VStack(alignment: .leading, spacing: 5) {
        Text(viewModel.race.meetingName)
          .font(.headline)
        Text("Race \(viewModel.race.raceNumber)")
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      Text(viewModel.remainingTime)
        .font(.headline)
        .monospaced()
        .contentTransition(.numericText())
        .foregroundStyle(viewModel.isRunningOutOfTime ? .red : .primary)
        .animation(.default, value: viewModel.remainingTime)
    }
    .padding()
    .background(colorScheme == .light ? .white : .gray.opacity(0.3))
    .cornerRadius(8)
    .shadow(radius: 2)
    .padding(.horizontal)
    .onAppear { viewModel.updateRemainingTime() }
    .onReceive(timer) { _ in
      viewModel.updateRemainingTime()
    }
  }
}

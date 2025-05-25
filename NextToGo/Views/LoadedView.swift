//
//  LoadedView.swift
//  NextToGo
//
//  Created by Farhad Bagherzadeh on 26/5/2025.
//

import SwiftUI

struct LoadedView: View {
  let races: [RaceSummary]
  let removeRaceAction: (String) -> Void

  var body: some View {
    ScrollView {
      ForEach(races) { race in
        RaceRow(
          race: race,
          pastOneMinuteAction: { removeRaceAction(race.raceID) }
        )
      }
      .padding(.top, 10)
    }
  }
}

struct RaceRow: View {
  let race: RaceSummary
  let pastOneMinuteAction: () -> Void

  @State private var remainingTime: String = ""
  @Environment(\.colorScheme) private var colorScheme
  private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 5) {
        Text(race.meetingName)
          .font(.headline)
        Text("Race \(race.raceNumber)")
          .font(.subheadline)
          .foregroundColor(.secondary)
      }

      Spacer()

      Text(remainingTime)
        .font(.headline)
        .frame(alignment: .trailing)
        .monospaced()
        .contentTransition(.numericText())
    }
    .padding()
    .background(colorScheme == .light ? .white : .gray.opacity(0.3))
    .cornerRadius(8)
    .shadow(radius: 2)
    .padding(.horizontal)
    .onAppear { updateRemainingTime() }
    .onReceive(timer) { _ in
      updateRemainingTime()
    }
  }

  // Calculate remaining time and update the state
  private func updateRemainingTime() {
    let now = Date.now
    let timeInterval = race.raceStartDate.timeIntervalSince(now)

    // Calculate 1 minute past advertised time
    let oneMinutePastStart = race.raceStartDate.addingTimeInterval(60)
    let timeIntervalWithGracePeriod = oneMinutePastStart.timeIntervalSince(now)

    if timeInterval > 0 {
      // Showing positive countdown
      let totalSeconds = Int(timeInterval)
      let minutes = totalSeconds / 60
      let seconds = totalSeconds % 60
      withAnimation {
        remainingTime = totalSeconds >= 60 ? "\(minutes) m" : "\(seconds) s"
      }
    } else {
      // Showing negative countdown
      let totalNegativeSeconds = abs(Int(timeIntervalWithGracePeriod))
      let negativeMinutes = totalNegativeSeconds / 60
      let negativeSeconds = totalNegativeSeconds % 60
      if negativeMinutes >= 1 {
        pastOneMinuteAction()
      } else {
        withAnimation {
          remainingTime = "-\(negativeSeconds) s"
        }
      }
    }
  }
}

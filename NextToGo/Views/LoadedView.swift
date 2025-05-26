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
        RaceRowView(
          race: race,
          pastOneMinuteAction: { removeRaceAction(race.raceID) }
        )
      }
      .padding(.top, 10)
    }
  }
}

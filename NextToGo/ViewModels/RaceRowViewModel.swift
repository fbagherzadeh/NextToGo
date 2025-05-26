//
//  RaceRowViewModel.swift
//  NextToGo
//
//  Created by Farhad Bagherzadeh on 26/5/2025.
//

import Foundation

class RaceRowViewModel: ObservableObject {
  @Published var remainingTime: String = ""
  var isRunningOutOfTime: Bool = false

  let race: RaceSummary
  let pastOneMinuteAction: () -> Void

  init(
    race: RaceSummary,
    pastOneMinuteAction: @escaping () -> Void
  ) {
    self.race = race
    self.pastOneMinuteAction = pastOneMinuteAction
  }

  /// Calculate remaining time and update the state
  func updateRemainingTime() {
    let timeInterval = race.raceStartDate.timeIntervalSinceNow
    let totalSeconds = Int(timeInterval.rounded(.down))

    if totalSeconds < 60, !isRunningOutOfTime {
      isRunningOutOfTime = true
    }

    if totalSeconds > 0 {
      // Showing positive countdown
      let minutes = totalSeconds / 60
      let seconds = totalSeconds % 60
      remainingTime = totalSeconds >= 60 ? "\(minutes)m \(seconds)s" : "\(seconds)s"
    } else {
      // Showing negative countdown
      if totalSeconds < -59 {
        pastOneMinuteAction()
      } else {
        remainingTime = "\(totalSeconds)s"
      }
    }
  }
}

extension RaceSummary {
  var imageName: String? {
    switch categoryID {
    case FilterType.greyhound.categoryId: FilterType.greyhound.rawValue
    case FilterType.horse.categoryId: FilterType.horse.rawValue
    case FilterType.harness.categoryId: FilterType.harness.rawValue
    default: nil
    }
  }
}

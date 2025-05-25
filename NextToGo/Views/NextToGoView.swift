//
//  ContentView.swift
//  NextToGo
//
//  Created by Farhad Bagherzadeh on 24/5/2025.
//

import SwiftUI

struct NextToGoView: View {
  @StateObject var viewModel: NextToGoViewModel = .init()

  var body: some View {
    NavigationStack {
      VStack(spacing: .zero) {
        FilterSelectionView($viewModel.selectedFilter)
        Divider()

        switch viewModel.viewState {
        case .loading:
          LoadingView()
        case .empty:
          NoContentView(filterName: viewModel.selectedFilter.rawValue.capitalized)
        case .somethingWentWrong:
          SomethingWentWrongView(retryAction: viewModel.loadRaces)
        case let .loaded(races):
          LoadedView(
            races: races,
            removeRaceAction: viewModel.removeRace(_:)
          )
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      .navigationTitle("Next to go")
      .navigationBarTitleDisplayMode(.large)
      .onAppear {
        viewModel.loadRaces()
      }
    }
  }
}

struct FilterSelectionView: View {
  @Binding var selectedFilter: FilterType
  @Namespace private var animation
  private let animationId: String = "ACTIVETAB"

  init(_ selectedFilter: Binding<FilterType>) {
    self._selectedFilter = selectedFilter
  }

  var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 10) {
        ForEach(FilterType.allCases, id: \.self) { type in
          Text(type.rawValue.capitalized)
            .fontWeight(.semibold)
            .foregroundStyle(selectedFilter == type ? .white : .gray)
            .padding(.horizontal, 20)
            .frame(height: 30)
            .background {
              if selectedFilter == type {
                Capsule()
                  .fill(.blue.gradient)
                  .matchedGeometryEffect(id: animationId, in: animation)
              }
            }
            .contentShape(.rect)
            .onTapGesture {
              withAnimation(.snappy) {
                selectedFilter = type
              }
            }
        }
      }
    }
    .scrollIndicators(.hidden)
    .scrollPosition(
      id: .init(
        get: { selectedFilter },
        set: { _ in }
      ),
      anchor: .center
    )
    .padding(10)
  }
}

struct LoadingView: View {
  var body: some View {
    VStack(spacing: 20) {
      ProgressView()
        .scaleEffect(1.5)

      Text("Loading races...")
        .font(.headline)
        .foregroundStyle(.gray)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

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

struct SomethingWentWrongView: View {
  let retryAction: () -> Void

  var body: some View {
    ContentUnavailableView(
      label: { Label("Something went wrong", systemImage: "x.circle") },
      description: { Text("Please try again") },
      actions: { Button("Retry") { retryAction() } }
    )
  }
}

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

#Preview {
  NextToGoView()
}


// MARK: - playground
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

    if timeIntervalWithGracePeriod > 0 {
      // Showing positive countdown
      let totalSeconds = Int(timeInterval)
      let minutes = totalSeconds / 60
      let seconds = totalSeconds % 60
      withAnimation {
        remainingTime = totalSeconds >= 60 ? "\(minutes) m" : "\(seconds) s"
      }
    } else {
      // Showing negative countdown
      let totalNegativeSeconds = Int(-timeIntervalWithGracePeriod)
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

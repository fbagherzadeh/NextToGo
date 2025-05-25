//
//  ContentView.swift
//  NextToGo
//
//  Created by Farhad Bagherzadeh on 24/5/2025.
//

import SwiftUI

struct NextToGoView: View {
  @StateObject var viewModel: NextToGoViewModel = .init()
  @Namespace private var animation
  private let animationId: String = "ACTIVETAB"

  var body: some View {
    NavigationStack {
      VStack(spacing: .zero) {
        /// Filter selection view
        ScrollView(.horizontal) {
          HStack(spacing: 10) {
            ForEach(FilterType.allCases, id: \.self) { type in
              Text(type.rawValue.capitalized)
                .fontWeight(.semibold)
                .foregroundStyle(viewModel.selectedFilterType == type ? .white : .gray)
                .padding(.horizontal, 20)
                .frame(height: 30)
                .background {
                  if viewModel.selectedFilterType == type {
                    Capsule()
                      .fill(.blue.gradient)
                      .matchedGeometryEffect(id: animationId, in: animation)
                  }
                }
                .contentShape(.rect)
                .onTapGesture {
                  withAnimation(.snappy) {
                    viewModel.selectedFilterType = type
                  }
                }
            }
          }
        }
        .scrollIndicators(.hidden)
        .scrollPosition(
          id: .init(
            get: { viewModel.selectedFilterType },
            set: { _ in }
          ),
          anchor: .center
        )
        .padding(10)

        Divider()

        switch viewModel.selectedFilterType {
        case .all:
          /// Content view
          let races = [
            Race(meetingName: "Melbourne Cup", raceNumber: "1", advertisedStart: Date().addingTimeInterval(120)),
            Race(meetingName: "Sydney Derby", raceNumber: "2", advertisedStart: Date().addingTimeInterval(360)),
            Race(meetingName: "Spring Carnival", raceNumber: "3", advertisedStart: Date().addingTimeInterval(600))
          ]
          ScrollView {
            ForEach(races) { race in
              RaceRow(race: race)
            }
            .padding(.top, 10)
          }

        case .greyhound:
          /// Loading view
          VStack(spacing: 20) {
            ProgressView()
              .scaleEffect(1.5)

            Text("Loading races...")
              .font(.headline)
              .foregroundStyle(.gray)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .horse:
          /// No content view
          ContentUnavailableView(
            "No results for \(viewModel.selectedFilterType.rawValue.capitalized)",
            systemImage: "flag.pattern.checkered",
            description: Text("Visit later or try other categories")
          )
        case .harness:
          /// Sth went wrong view
          ContentUnavailableView(
            label: { Label("Something went wrong", systemImage: "x.circle") },
            description: { Text("Please try again") },
            actions: { Button("Retry") {  } }
          )
        }


      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      .navigationTitle("Next to go")
      .onAppear {
        viewModel.loadRaces()
      }
    }
  }
}

#Preview {
  NextToGoView()
}


// MARK: - playground
struct Race: Identifiable {
  let id: String = UUID().uuidString
  let meetingName: String
  let raceNumber: String
  let advertisedStart: Date
}

struct RaceRow: View {
  let race: Race
  @Environment(\.colorScheme) var colorScheme

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

      VStack {
        Text("\(countdown(from: race.advertisedStart))")
          .font(.headline)
          .frame(alignment: .trailing)
      }
    }
    .padding()
    .background(colorScheme == .light ? .white : .gray.opacity(0.3))
    .cornerRadius(8)
    .shadow(radius: 2)
    .padding(.horizontal)
  }

  // Countdown function to calculate the time remaining
  private func countdown(from date: Date) -> String {
    let remaining = date.timeIntervalSinceNow
    guard remaining > 0 else {
      return "Starting..."
    }

    let minutes = Int(remaining) / 60
    let seconds = Int(remaining) % 60
    return String(format: "%02d:%02d", minutes, seconds) // Format as MM:SS
  }
}

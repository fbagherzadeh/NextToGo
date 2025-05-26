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
        FilterSelectionView(
          selectedFilter: viewModel.selectedFilter,
          onChangeFilter: { viewModel.updateLoadedState(with: $0) }
        )

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

#Preview {
  NextToGoView()
}

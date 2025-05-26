//
//  FilterSelectionView.swift
//  NextToGo
//
//  Created by Farhad Bagherzadeh on 26/5/2025.
//

import SwiftUI

struct FilterSelectionView: View {
  let selectedFilter: FilterType
  let onChangeFilter: (FilterType) -> Void

  @Namespace private var animation
  private let animationId: String = "ACTIVETAB"

  init(
    selectedFilter: FilterType,
    onChangeFilter: @escaping (FilterType) -> Void
  ) {
    self.selectedFilter = selectedFilter
    self.onChangeFilter = onChangeFilter
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
                onChangeFilter(type)
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

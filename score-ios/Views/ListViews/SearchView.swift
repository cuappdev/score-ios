//
//  SearchView.swift
//  score-ios
//
//  Created by Zain Bilal on 10/5/25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Constants.Colors.gray_text)

                TextField("Search keywords", text: $searchText)
                    .foregroundColor(Constants.Colors.gray_text)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                if !searchText.isEmpty {
                    Button(action: {
                        self.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Constants.Colors.gray_text)
                    }
                }
            }
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Constants.Colors.gray_border, lineWidth: 1)
            )
            
        }
    }
}

#Preview {
    SearchView()
}

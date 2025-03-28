//
//  FilterSheetView.swift
//  score-ios
//
//  Created by Hsia Lu wu on 3/26/25.
//

import SwiftUI

struct FilterSheetView: View {
    @State private var isPriceExpanded = false
    @State private var isLocationExpanded = false
    @State private var isDateExpanded = false
    
    @Binding var selectedPrice: String
    @Binding var selectedLocation: String
    @Binding var selectedDate: String
    
    var body: some View {
        VStack(spacing: 20) {
            // price section
            filterSection(sectionName: "Price", options: FilterOptions.priceOptions, isExpanded: $isPriceExpanded, selectedOption: $selectedPrice)
            
            // location section
            filterSection(sectionName: "Location", options: FilterOptions.locationOptions, isExpanded: $isLocationExpanded, selectedOption: $selectedLocation)
            
            // date section
            filterSection(sectionName: "Date of Game", options: FilterOptions.dateOptions, isExpanded: $isDateExpanded, selectedOption: $selectedDate)
            
            // apply button
            Button {
                // action: apply filter
            } label: {
                Text("Apply")
                    .font(Constants.Fonts.Body.medium)
                    .foregroundStyle(Constants.Colors.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(height: 40)
                            .foregroundStyle(Constants.Colors.primary_red)
                            .padding(.horizontal, 16)
                    }
            }
            
            // reset button
            Button {
                // action: reset filter
                selectedPrice = ""
                selectedLocation = ""
                selectedDate = ""
            } label: {
                
            }
            
        }
    }
}

// MARK: Functions
extension FilterSheetView {
    // makes the filter section
    func filterSection(sectionName: String, options: [String], isExpanded: Binding<Bool>, selectedOption: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(sectionName)
                    .font(Constants.Fonts.Header.h2)
                    .foregroundStyle(Constants.Colors.dark_gray_text)
                
                Spacer()
                
                Button {
                    withAnimation {
                        isExpanded.wrappedValue.toggle()
                    }
                } label: {
                    Image(isExpanded.wrappedValue ? "Minus" : "Plus")
                        .resizable()
                        .frame(width: 27, height: 27)
                }
            }
            .padding(.horizontal, 16)
            
            if (isExpanded.wrappedValue) {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(options, id: \.self) { option in
                        Button {
                            selectedOption.wrappedValue = option
                        } label: {
                            HStack {
                                Image(systemName: selectedOption.wrappedValue == option ? "largecircle.fill.circle" : "circle")
                                    .foregroundStyle(Constants.Colors.black)
                                
                                Text(option)
                                    .font(Constants.Fonts.Body.normal)
                                    .foregroundStyle(Constants.Colors.dark_gray_text)
                            }
                        }
                    }
                }
                .frame(height: isExpanded.wrappedValue ? nil : 0)
                .clipped()
                .animation(.easeInOut, value: isExpanded.wrappedValue)
                .padding(.horizontal, 16)
            }
        }
    }
}

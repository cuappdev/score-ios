//
//  ReportSuccessView.swift
//  score-ios
//
//  Created by Duru Alaylı on 11/3/26.
//

import SwiftUI

struct ReportSuccessView: View {

    // MARK: - Properties

    var onSubmitAnother: (() -> Void)?
    var onReturn: (() -> Void)?

    // MARK: - UI

    var body: some View {
        VStack(spacing: 0) {
            header
            Spacer()
            VStack(spacing: 60) {
                completion
                buttons
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Header

    private var header: some View {
        Text("Report an issue")
            .font(Constants.Fonts.medium18)
            .foregroundStyle(Constants.Colors.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Constants.Colors.white)
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
            .zIndex(1)
    }

    // MARK: - Completion

    private var completion: some View {
        VStack(spacing: 26) {
            Image("check")
                .resizable()
                .renderingMode(.template)
                .frame(width: 110, height: 110)
                .foregroundStyle(Constants.Colors.green)
            VStack(spacing: 10) {
                Text("Thank you for your input!")
                    .font(Constants.Fonts.semibold18)
                    .foregroundStyle(Constants.Colors.primary_gray)
                Text("Your report has been submitted.")
                    .font(Constants.Fonts.body)
                    .foregroundStyle(Constants.Colors.primary_gray)
            }
        }
    }

    // MARK: - Buttons

    private var buttons: some View {
        VStack(spacing: 40) {
            Button {
                onSubmitAnother?()
            } label: {
                Text("Submit another")
                    .font(Constants.Fonts.buttonLabel)
                    .foregroundStyle(Constants.Colors.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Constants.Colors.gray_border)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 4)
            }
            Button {
                onReturn?()
            } label: {
                HStack(spacing: 0) {
                    Text("Return to Profile")
                        .font(Constants.Fonts.medium16)
                        .foregroundStyle(Constants.Colors.gray_text)
                    Image("Arrowhead")
                        .resizable()
                        .frame(width: 16, height: 14)
                }
            }
        }
    }
}

#Preview {
    ReportSuccessView()
}

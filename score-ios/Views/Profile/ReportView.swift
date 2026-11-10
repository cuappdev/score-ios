//
//  ReportView.swift
//  score-ios
//
//  Created by Duru Alaylı on 10/22/26.
//

import SwiftUI

struct ReportView: View {

    // MARK: - Properties

    var onReturnToProfile: (() -> Void)?
    @Environment(\.dismiss) private var dismiss
    @State private var issue: String?
    @State private var sport: String?
    @State private var details = ""
    @State private var showErrors = false
    @State private var showSuccess = false

    private let issueOptions = ["Inaccurate scores", "Wrong game time", "Missing game", "Other"]
    private let sportOptions = Sport.allCases.filter { $0 != .All }.map(\.description)

    // MARK: - UI

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    question(title: "What was the issue?")
                    Dropdown(
                        placeholder: "Choose an option ...",
                        options: issueOptions,
                        selection: $issue,
                        showError: showErrors && issue == nil
                    )

                    question(title: "Which sport does it concern?")
                    Dropdown(placeholder: "Choose an option ...", options: sportOptions, selection: $sport)

                    description
                    submitButton
                }
                .padding(24)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $showSuccess) {
            ReportSuccessView(
                onSubmitAnother: {
                    resetForm()
                    showSuccess = false
                },
                onReturn: onReturnToProfile
            )
        }
    }

    // MARK: - Header

    private var header: some View {
        ZStack {
            Text("Report an issue")
                .font(Constants.Fonts.medium18)
                .foregroundStyle(Constants.Colors.black)
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("arrow_back_ios")
                        .resizable()
                        .frame(width: 9.87, height: 18.57)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Constants.Colors.white)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        .zIndex(1)
    }

    // MARK: - Form

    private func question(title: String) -> some View {
        Text(title)
            .font(Constants.Fonts.medium18)
            .foregroundStyle(Constants.Colors.primary_gray)
    }

    private var description: some View {
        VStack(alignment: .leading, spacing: 16) {
            question(title: "Describe what's wrong for us.")

            ZStack(alignment: .topLeading) {
                TextEditor(text: $details)
                    .font(Constants.Fonts.body)
                    .foregroundStyle(Constants.Colors.primary_gray)
                    .scrollContentBackground(.hidden)
                    .padding(8)

                if details.isEmpty {
                    Text("What happened?")
                        .font(Constants.Fonts.body)
                        .foregroundStyle(Constants.Colors.gray_icons)
                        .padding(.horizontal, 13)
                        .padding(.vertical, 16)
                        .allowsHitTesting(false)
                }
            }
            .frame(height: 240)
            .background(Constants.Colors.gray_border)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private var submitButton: some View {
        Button {
            guard issue != nil else {
                showErrors = true
                return
            }
            // TODO: send the report once the backend supports it
            showSuccess = true
        } label: {
            Text("Submit")
                .font(Constants.Fonts.Header.h3)
                .foregroundStyle(Constants.Colors.white)
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(Constants.Colors.crimson)
                .clipShape(Capsule())
        }
    }

    // MARK: - Helpers

    private func resetForm() {
        issue = nil
        sport = nil
        details = ""
        showErrors = false
    }
}

// MARK: - Dropdown

private struct Dropdown: View {
    let placeholder: String
    let options: [String]
    @Binding var selection: String?
    var showError = false
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 0) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { isExpanded.toggle() }
                } label: {
                    HStack {
                        Text(selection ?? placeholder)
                            .font(Constants.Fonts.body)
                            .foregroundStyle(selection == nil ? Constants.Colors.gray_icons : Constants.Colors.primary_gray)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(Constants.Colors.gray_icons)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                    .padding(12)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                if isExpanded {
                    VStack(spacing: 0) {
                        ForEach(options, id: \.self) { option in
                            Button {
                                selection = option
                                withAnimation(.easeInOut(duration: 0.2)) { isExpanded = false }
                            } label: {
                                Text(option)
                                    .font(Constants.Fonts.body)
                                    .foregroundStyle(Constants.Colors.primary_gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 10)
                                    .background(option == selection ? Constants.Colors.gray_liner : .clear)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 6)
                    .padding(.bottom, 8)
                }
            }
            .background(Constants.Colors.gray_border)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Constants.Colors.crimson, lineWidth: showError ? 1 : 0)
            )

            if showError {
                Text("This is a required field.")
                    .font(Constants.Fonts.Label.normal)
                    .foregroundStyle(Constants.Colors.crimson)
            }
        }
    }
}

#Preview {
    ReportView()
}

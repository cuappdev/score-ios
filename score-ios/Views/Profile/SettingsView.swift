//
//  SettingsView.swift
//  score-ios
//
//  Created by Duru Alaylı on 10/20/26.
//

import SwiftUI

struct SettingsView: View {

    // MARK: - Properties

    var onReturnToProfile: (() -> Void)?
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var auth = AuthManager.shared
    @State private var showDeleteConfirmation = false
    @State private var showReport = false
    @State private var showAbout = false

    // MARK: - Rows

    private var help: [SettingsRow] {
        var rows = [
            SettingsRow(icon: "info", title: "About Score") {
                showAbout = true
            },
            SettingsRow(icon: "outlined_flag", title: "Report an Issue") {
                showReport = true
            }
        ]
        if auth.currentUser != nil {
            rows += [
                SettingsRow(icon: "logout", title: "Log Out", isDestructive: true) {
                    Task { await auth.logOut() }
                },
                SettingsRow(icon: "delete_outline", title: "Delete Account", isDestructive: true) {
                    withAnimation(.easeInOut(duration: 0.2)) { showDeleteConfirmation = true }
                }
            ]
        }
        return rows
    }

    // MARK: - UI

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                section(title: "Help", rows: help)
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
            }
        }
        .overlay {
            if showDeleteConfirmation {
                deleteConfirmation
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $showReport) {
            ReportView(onReturnToProfile: onReturnToProfile)
        }
        .navigationDestination(isPresented: $showAbout) {
            AboutView()
        }
    }

    // MARK: - Header

    private var header: some View {
        ZStack {
            Text("Settings")
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

    // MARK: - Section

    private func section(title: String, rows: [SettingsRow]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(Constants.Fonts.Body.medium)
                .foregroundStyle(Constants.Colors.primary_gray)
            VStack(spacing: 0) {
                ForEach(rows) { item in
                    row(item)
                    if item.id != rows.last?.id {
                        Divider()
                            .background(Constants.Colors.gray_border)
                            .padding(.horizontal, 16)
                    }
                }
            }
            .background(Constants.Colors.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Constants.Colors.gray_border, lineWidth: 1)
            )
        }
    }

    // MARK: - Row

    private func row(_ item: SettingsRow) -> some View {
        let color = item.isDestructive ? Constants.Colors.crimson : Constants.Colors.primary_gray
        return Button(action: item.action) {
            HStack {
                HStack(spacing: 10) {
                    Image(item.icon)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 32, height: 32)
                        .foregroundStyle(color)
                    Text(item.title)
                        .font(Constants.Fonts.medium16)
                        .foregroundStyle(color)
                }
                Spacer()
                if !item.isDestructive {
                    Image("Arrowhead")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            .padding(16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Confirmation

    private var deleteConfirmation: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture { hideDeleteConfirmation() }
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Delete your account?")
                        .font(Constants.Fonts.Body.bold)
                        .foregroundStyle(Constants.Colors.primary_gray)
                    Text("This will permanently delete your account and cannot be undone.")
                        .font(Constants.Fonts.Label.normal)
                        .foregroundStyle(Constants.Colors.primary_gray)
                        .multilineTextAlignment(.center)
                }
                HStack(spacing: 8) {
                    Button {
                        hideDeleteConfirmation()
                    } label: {
                        Text("Keep account")
                            .font(Constants.Fonts.Label.medium)
                            .foregroundStyle(Constants.Colors.gray_icons)
                            .fixedSize()
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .overlay(Capsule().stroke(Constants.Colors.gray_border, lineWidth: 1))
                    }
                    Button {
                        hideDeleteConfirmation()
                    } label: {
                        Text("Delete")
                            .font(Constants.Fonts.Label.medium)
                            .foregroundStyle(Constants.Colors.white)
                            .fixedSize()
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(Constants.Colors.crimson)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(24)
            .background(Constants.Colors.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(.horizontal, 74)
        }
        .transition(.opacity)
    }
    private func hideDeleteConfirmation() {
        withAnimation(.easeInOut(duration: 0.2)) { showDeleteConfirmation = false }
    }
}

// MARK: - Settings Row

private struct SettingsRow: Identifiable {
    let icon: String
    let title: String
    var isDestructive = false
    let action: () -> Void
    var id: String { title }
}

#Preview {
    SettingsView()
}

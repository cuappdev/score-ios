//
//  SignInToSaveSheet.swift
//  score-ios
//

import SwiftUI

struct SignInToSaveSheet: View {
    @StateObject private var loginViewModel = LoginViewModel()
    let onDismiss: () -> Void
    let onAuthenticated: () -> Void

    private let buttonCornerRadius: CGFloat = 14

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button("Close", systemImage: "xmark", action: onDismiss)
                    .labelStyle(.iconOnly)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 32, height: 32)
                    .contentShape(Circle())
                    .modifier(SheetCloseGlass())
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)

            VStack(alignment: .leading, spacing: 12) {
                Text("Sign In to Save")
                    .font(Constants.Fonts.semibold18)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button(action: signIn) {
                    Text("Sign In")
                        .font(Constants.Fonts.Header.h3)
                        .foregroundStyle(Constants.Colors.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Constants.Colors.primary_red, in: .rect(cornerRadius: buttonCornerRadius))
                }
                .buttonStyle(.plain)

                Button(action: signIn) {
                    Text("Create an Account")
                        .font(Constants.Fonts.Header.h3)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.clear, in: .rect(cornerRadius: buttonCornerRadius))
                        .overlay {
                            RoundedRectangle(cornerRadius: buttonCornerRadius)
                                .strokeBorder(Constants.Colors.gray_liner.opacity(0.9), lineWidth: 1)
                        }
                }
                .buttonStyle(.plain)

                Button("Not now", action: onDismiss)
                    .font(Constants.Fonts.Body.normal)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
            }
            .padding(.horizontal, 24)
            .padding(.top, 4)
            .padding(.bottom, 20)
        }
        // Intentionally no opaque sheet background — use the system glass presentation.
        .alert(loginViewModel.errorText, isPresented: $loginViewModel.didPresentError) {
            Button("OK", role: .cancel) {}
        }
        .presentationDetents([.height(280)])
        .presentationDragIndicator(.visible)
    }

    private func signIn() {
        Task {
            // Present Google over this sheet (LoginViewModel uses the top VC).
            // Dismissing first forced a visible pause before anything appeared.
            guard await loginViewModel.signIn() != nil else { return }
            onAuthenticated()
        }
    }
}

private struct SheetCloseGlass: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.glassEffect(.regular.interactive(), in: .circle)
        } else {
            content
                .background(.ultraThinMaterial, in: .circle)
        }
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            SignInToSaveSheet(onDismiss: {}, onAuthenticated: {})
        }
}

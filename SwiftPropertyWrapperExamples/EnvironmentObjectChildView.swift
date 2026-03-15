//
//  EnvironmentObjectChildView.swift
//  SwiftPropertyWrapperExamples
//
//  Created by Nikhil Bajpai on 03/03/26.
//
//  A nested child view that demonstrates @EnvironmentObject depth.
//
//  KEY POINT: This file has NO knowledge of how it received AppSettingsViewModel.
//  No init parameter. No import of a parent. It simply declares @EnvironmentObject
//  and SwiftUI pulls it automatically from the environment injected by an ancestor.
//
//  If the ancestor forgot to call .environmentObject(...), this view crashes at
//  runtime — the compiler cannot warn you. That is the trade-off.
//

import SwiftUI

struct EnvironmentObjectChildView: View {
    // @EnvironmentObject: pulled implicitly from the SwiftUI environment.
    // No init parameter required — this is what makes it different from @ObservedObject.
    @EnvironmentObject var viewModel: AppSettingsViewModel

    var body: some View {
        VStack(spacing: 12) {
            Text("EnvironmentObjectChildView")
                .font(.headline)
                .foregroundColor(viewModel.darkModeEnabled ? .white : .black)

            Text("This is a NESTED child view.\nIt received the view model with zero init parameters.\nJust @EnvironmentObject and SwiftUI handles the rest.")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(viewModel.darkModeEnabled ? .white.opacity(0.7) : .black.opacity(0.7))

            // Reads notificationsEnabled to prove it's the same shared object
            // that @ObservedObject demo also touches.
            Text("Notifications (set in @ObservedObject screen): \(viewModel.notificationsEnabled ? "ON" : "OFF")")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(viewModel.darkModeEnabled ? Color.white.opacity(0.08) : Color.black.opacity(0.06))
        )
        .padding(.horizontal)
    }
}

#Preview {
    // @EnvironmentObject previews MUST inject the object or they crash.
    EnvironmentObjectChildView()
        .environmentObject(AppSettingsViewModel())
}

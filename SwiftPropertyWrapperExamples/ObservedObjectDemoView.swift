//
//  ObservedObjectDemoView.swift
//  SwiftPropertyWrapperExamples
//
//  Created by Nikhil Bajpai on 03/03/26.
//
//  This screen demonstrates @ObservedObject.
//
//  KEY RULE: @ObservedObject does NOT create the object — it only subscribes to one
//  that was created and passed in by a parent. If the parent is torn down, the object
//  goes with it. If this view is torn down and re-created, the object survives because
//  it is owned upstream (ContentView holds it as @StateObject).
//

import SwiftUI

struct ObservedObjectDemoView: View {
    // @ObservedObject: subscribe to an externally-owned object.
    // This instance was created by ContentView and passed in via the NavigationLink.
    // Mutating it here mutates the SAME object ContentView owns.
    @ObservedObject var viewModel: AppSettingsViewModel

    var body: some View {
        ZStack {
            Color(viewModel.darkModeEnabled ? .black : .white)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("@ObservedObject Demo")
                    .font(.title)
                    .bold()
                    .foregroundColor(viewModel.darkModeEnabled ? .white : .black)

                Text("This view did NOT create this object.\nIt was handed in by the parent (ContentView).\nChanges here affect the same object every other screen sees.")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(viewModel.darkModeEnabled ? .white.opacity(0.8) : .black.opacity(0.8))

                Divider()

                // Toggling notificationsEnabled on the shared object.
                // Navigate to the @EnvironmentObject screen — you will see darkModeEnabled
                // is separate, but notificationsEnabled is on the SAME viewModel instance.
                Toggle(isOn: $viewModel.notificationsEnabled) {
                    Text("Notifications (shared @ObservedObject)")
                        .foregroundColor(viewModel.darkModeEnabled ? .white : .black)
                }
                .toggleStyle(.switch)
                .padding(.horizontal)

                Text("Notifications: \(viewModel.notificationsEnabled ? "ON" : "OFF")")
                    .font(.headline)
                    .foregroundColor(viewModel.darkModeEnabled ? .white : .black)

                Divider()

                // Reading username proves this is the same object as the parent.
                // If you change username in the @StateObject demo, it will NOT appear
                // here — that screen uses a SEPARATE private instance.
                Text("Username on this object: \"\(viewModel.username)\"")
                    .font(.footnote)
                    .foregroundColor(viewModel.darkModeEnabled ? .white.opacity(0.6) : .black.opacity(0.6))

                Text("(Change username in the @StateObject demo — it uses a separate instance, so it won't affect this readout.)")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("@ObservedObject")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ObservedObjectDemoView(viewModel: AppSettingsViewModel())
    }
}

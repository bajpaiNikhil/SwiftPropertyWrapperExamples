//
//  EnvironmentObjectDemoView.swift
//  SwiftPropertyWrapperExamples
//
//  Created by Nikhil Bajpai on 03/03/26.
//
//  This screen demonstrates @EnvironmentObject.
//
//  KEY RULE: @EnvironmentObject does not receive the object through an init parameter.
//  It is pulled implicitly from the SwiftUI environment, seeded by an ancestor using
//  .environmentObject(...). This avoids "prop drilling" — passing objects through
//  every layer of a deep view hierarchy just to reach a distant child.
//
//  TRADE-OFF: If the ancestor forgot to inject the object, the app crashes at runtime.
//  The compiler gives you no warning. Use @EnvironmentObject for truly app-wide state.
//

import SwiftUI

struct EnvironmentObjectDemoView: View {
    // @EnvironmentObject: no init parameter.
    // SwiftUI finds this by type in the environment and injects it automatically.
    // ContentView seeded it via .environmentObject(settingsViewModel) on the NavigationStack.
    @EnvironmentObject var viewModel: AppSettingsViewModel

    var body: some View {
        ZStack {
            Color(viewModel.darkModeEnabled ? .black : .white)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("@EnvironmentObject Demo")
                    .font(.title)
                    .bold()
                    .foregroundColor(viewModel.darkModeEnabled ? .white : .black)

                Text("This view has NO init parameter for the view model.\nIt was injected by ContentView via .environmentObject()\nand is available to every view in the subtree.")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(viewModel.darkModeEnabled ? .white.opacity(0.8) : .black.opacity(0.8))

                Divider()

                // Toggling darkModeEnabled on the shared object.
                // This is the same property ContentView's @State demo uses,
                // showing that the environment object is app-wide.
                Toggle(isOn: $viewModel.darkModeEnabled) {
                    Text("Dark Mode (via @EnvironmentObject)")
                        .foregroundColor(viewModel.darkModeEnabled ? .white : .black)
                }
                .toggleStyle(.switch)
                .padding(.horizontal)

                Text("Dark Mode: \(viewModel.darkModeEnabled ? "ON" : "OFF")")
                    .font(.headline)
                    .foregroundColor(viewModel.darkModeEnabled ? .white : .black)

                Divider()

                // The child view below also uses @EnvironmentObject — with zero
                // parameters passed from this view to it.
                Text("Below is a nested child view that also uses @EnvironmentObject with no init params:")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                EnvironmentObjectChildView()
            }
            .padding()
        }
        .navigationTitle("@EnvironmentObject")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    // Must inject or the preview crashes — this is the @EnvironmentObject trade-off.
    NavigationStack {
        EnvironmentObjectDemoView()
            .environmentObject(AppSettingsViewModel())
    }
}

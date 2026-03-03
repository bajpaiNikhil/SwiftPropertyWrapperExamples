//
//  ContentView.swift
//  SwiftPropertyWrapperExamples
//
//  Created by Nikhil Bajpai on 03/03/26.
//
//  This screen demonstrates @State — a source of truth owned by this view.
//  It also presents a second screen that uses @Binding to mutate the same state
//  from a child view.
//

import SwiftUI

struct ContentView: View {
    // @State: A value type owned by this view. When it changes, the view re-renders.
    @State private var darkModeEnabled: Bool = false

    // @State used to control presentation of the details screen.
    @State private var showDetailsView: Bool = false

    var body: some View {
        ZStack {
            // Background color reacts to the @State value.
            Color(darkModeEnabled ? .black : .white)
                .animation(.default, value: darkModeEnabled)

            VStack(spacing: 24) {
                // Title and explanation for the POC
                Text("Home • @State Demo")
                    .font(.title)
                    .bold()
                    .foregroundColor(darkModeEnabled ? .white : .black)

                Text("This screen owns the source of truth using @State.\nToggling below updates the UI locally.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(darkModeEnabled ? .white.opacity(0.8) : .black.opacity(0.8))

                // Readout that reflects current state
                Text("Dark Mode is \(darkModeEnabled ? "ON" : "OFF")")
                    .font(.headline)
                    .foregroundColor(darkModeEnabled ? .white : .black)

                // Local mutation of @State — demonstrates how this view can update its own state
                Toggle(isOn: $darkModeEnabled) {
                    Text("Dark Mode (local @State)")
                        .foregroundColor(darkModeEnabled ? .white : .black)
                }
                .toggleStyle(.switch)
                .padding(.horizontal)

                // Navigate to the Binding demo
                Button {
                    showDetailsView.toggle()
                } label: {
                    Text("Show Details (@Binding Demo)")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(darkModeEnabled ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                        .clipShape(Capsule())
                        .foregroundColor(darkModeEnabled ? .white : .black)
                }
            }
            .padding()
        }
        // Present the details view that receives bindings to mutate state from the child.
        .sheet(isPresented: $showDetailsView, content: {
            DetailView(
                // Pass a binding so the child can dismiss itself
                isPresented: $showDetailsView,
                // Pass a binding so the child can toggle dark mode and reflect back here
                darkModeEnabled: $darkModeEnabled
            )
        })
        .ignoresSafeArea()
    }
}

#Preview {
    // Preview shows how the UI looks and behaves with default state
    ContentView()
}

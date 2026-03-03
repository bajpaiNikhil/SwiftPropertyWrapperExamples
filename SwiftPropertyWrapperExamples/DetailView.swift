//
//  DetailView.swift
//  SwiftPropertyWrapperExamples
//
//  Created by Nikhil Bajpai on 03/03/26.
//
//  This screen demonstrates @Binding — it does NOT own the data.
//  Instead, it receives a binding to the parent's @State so it can read and write it.
//

import SwiftUI

struct DetailView: View {
    // @Binding: A reference to state owned elsewhere (the parent view).
    // Mutating this value updates the parent's @State directly.
    @Binding var isPresented: Bool
    @Binding var darkModeEnabled: Bool

    var body: some View {
        ZStack {
            Color(darkModeEnabled ? .black : .white)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Details • @Binding Demo")
                    .font(.title)
                    .bold()
                    .foregroundColor(darkModeEnabled ? .white : .black)

                Text("This screen receives bindings to the parent's state.\nToggling below updates the same source of truth.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(darkModeEnabled ? .white.opacity(0.8) : .black.opacity(0.8))

                // Readout reflects the same state as the parent
                Text("Dark Mode is \(darkModeEnabled ? "ON" : "OFF")")
                    .font(.headline)
                    .foregroundColor(darkModeEnabled ? .white : .black)

                // Mutating via @Binding — this writes back to the parent's @State
                Toggle(isOn: $darkModeEnabled) {
                    Text("Dark Mode (via @Binding)")
                        .foregroundColor(darkModeEnabled ? .white : .black)
                }
                .toggleStyle(.switch)
                .padding(.horizontal)

                // Dismiss by mutating the bound isPresented value
                Button {
                    isPresented = false
                } label: {
                    Text("Dismiss")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(darkModeEnabled ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                        .clipShape(Capsule())
                        .foregroundColor(darkModeEnabled ? .white : .black)
                }
            }
            .padding()
        }
    }
}

#Preview {
    // Previews require constant bindings, which simulate fixed values for Xcode Preview
    DetailView(
        isPresented: .constant(true),
        darkModeEnabled: .constant(false)
    )
}

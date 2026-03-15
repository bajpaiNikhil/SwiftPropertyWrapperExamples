//
//  StateObjectDemoView.swift
//  SwiftPropertyWrapperExamples
//
//  Created by Nikhil Bajpai on 03/03/26.
//
//  This screen demonstrates @StateObject.
//
//  KEY RULE: @StateObject creates and OWNS the object. The initializer runs exactly
//  once for the lifetime of this view in the SwiftUI tree. Even if body is recalculated
//  many times, the object is never recreated.
//
//  CONTRAST WITH @ObservedObject: same object type, different ownership.
//  This screen's localViewModel is a completely SEPARATE instance from ContentView's
//  settingsViewModel. Changes here do not appear on any other screen.
//

import SwiftUI

struct StateObjectDemoView: View {
    // @StateObject: this view creates and owns the object.
    // SwiftUI guarantees this initializer runs only ONCE, no matter how many
    // times body is re-evaluated.
    @StateObject private var localViewModel = AppSettingsViewModel()

    // @State for comparison: also survives re-renders, but resets when the view
    // is removed from the tree (e.g. navigated away and back in some configurations).
    @State private var tempText: String = ""

    // Formatter to display createdAt timestamp in a readable way.
    private let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .medium
        return f
    }()

    var body: some View {
        ZStack {
            Color(localViewModel.darkModeEnabled ? .black : .white)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Text("@StateObject Demo")
                        .font(.title)
                        .bold()
                        .foregroundColor(localViewModel.darkModeEnabled ? .white : .black)

                    Text("This view OWNS its own private instance of AppSettingsViewModel.\nChanges here are local — they do NOT affect the @ObservedObject or @EnvironmentObject screens.")
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                        .foregroundColor(localViewModel.darkModeEnabled ? .white.opacity(0.8) : .black.opacity(0.8))

                    Divider()

                    // Editing username on the LOCAL instance.
                    // This proves the object is private — the @ObservedObject screen
                    // reads username from a DIFFERENT instance and won't see this change.
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Username (@StateObject-backed)")
                            .font(.caption)
                            .foregroundColor(.gray)

                        TextField("Enter username", text: $localViewModel.username)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                    }

                    Button("Reset Username") {
                        localViewModel.username = "Guest"
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.15))
                    .clipShape(Capsule())
                    .foregroundColor(.blue)

                    Divider()

                    // Side-by-side comparison with plain @State.
                    // Both survive re-renders. The conceptual difference:
                    // @State is for simple value types. @StateObject is for reference
                    // types with multiple @Published properties and business logic.
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Temp text (@State-backed — for comparison)")
                            .font(.caption)
                            .foregroundColor(.gray)

                        TextField("Type something...", text: $tempText)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                    }

                    Divider()

                    // The timestamp proves the object is created only once.
                    // Navigate away and come back — the time does not change.
                    VStack(spacing: 4) {
                        Text("Object created at:")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(timeFormatter.string(from: localViewModel.createdAt))
                            .font(.headline)
                            .foregroundColor(localViewModel.darkModeEnabled ? .white : .black)
                        Text("Navigate away and return — this timestamp will not change.\nThat proves @StateObject only initializes once.")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("@StateObject")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        StateObjectDemoView()
    }
}

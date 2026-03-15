//
//  ContentView.swift
//  SwiftPropertyWrapperExamples
//
//  Created by Nikhil Bajpai on 03/03/26.
//
//  This is the root hub of the demo app. It demonstrates two things directly:
//    1. @State — owns simple value-type state (darkModeEnabled, showDetailsView)
//    2. @StateObject — creates and owns AppSettingsViewModel for the whole tree
//
//  It then passes state/objects to child screens in three different ways:
//    - $binding       → DetailView       (@Binding demo)
//    - init param     → ObservedObjectDemoView (@ObservedObject demo)
//    - .environmentObject → EnvironmentObjectDemoView (@EnvironmentObject demo)
//    - nothing        → StateObjectDemoView (creates its own private instance)
//

import SwiftUI

struct ContentView: View {
    // @State: owns simple Bool value types local to this view.
    @State private var darkModeEnabled: Bool = false
    @State private var showDetailsView: Bool = false

    // @StateObject: creates and owns the shared reference-type view model.
    // This instance is passed to ObservedObjectDemoView via init param,
    // and injected into the environment for EnvironmentObjectDemoView.
    @StateObject private var settingsViewModel = AppSettingsViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(darkModeEnabled ? .black : .white)
                    .ignoresSafeArea()
                    .animation(.default, value: darkModeEnabled)

                ScrollView {
                    VStack(spacing: 24) {
                        Text("Property Wrapper Examples")
                            .font(.title)
                            .bold()
                            .foregroundColor(darkModeEnabled ? .white : .black)

                        Text("Tap each demo to explore how the wrapper works.\nThis view is the root — it owns @State and @StateObject.")
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                            .foregroundColor(darkModeEnabled ? .white.opacity(0.8) : .black.opacity(0.8))

                        Divider()

                        // ── @State demo (inline) ───────────────────────────────
                        SectionHeader(title: "@State", dark: darkModeEnabled)

                        Text("Dark Mode is \(darkModeEnabled ? "ON" : "OFF")")
                            .font(.headline)
                            .foregroundColor(darkModeEnabled ? .white : .black)

                        Toggle(isOn: $darkModeEnabled) {
                            Text("Dark Mode (local @State)")
                                .foregroundColor(darkModeEnabled ? .white : .black)
                        }
                        .toggleStyle(.switch)
                        .padding(.horizontal)

                        // ── @Binding demo (sheet) ──────────────────────────────
                        SectionHeader(title: "@Binding", dark: darkModeEnabled)

                        DemoButton(label: "Open @Binding Demo (sheet)", dark: darkModeEnabled) {
                            showDetailsView.toggle()
                        }

                        // ── @ObservedObject demo (push) ────────────────────────
                        SectionHeader(title: "@ObservedObject", dark: darkModeEnabled)

                        NavigationLink {
                            // Passing the SAME settingsViewModel owned here.
                            // That view subscribes via @ObservedObject — it does not own it.
                            ObservedObjectDemoView(viewModel: settingsViewModel)
                        } label: {
                            DemoLinkLabel(label: "Open @ObservedObject Demo", dark: darkModeEnabled)
                        }

                        // ── @StateObject demo (push) ───────────────────────────
                        SectionHeader(title: "@StateObject", dark: darkModeEnabled)

                        NavigationLink {
                            // No object passed in — StateObjectDemoView creates its own.
                            StateObjectDemoView()
                        } label: {
                            DemoLinkLabel(label: "Open @StateObject Demo", dark: darkModeEnabled)
                        }

                        // ── @EnvironmentObject demo (push) ─────────────────────
                        SectionHeader(title: "@EnvironmentObject", dark: darkModeEnabled)

                        NavigationLink {
                            // No init param — the view pulls settingsViewModel from
                            // the environment injected by .environmentObject() below.
                            EnvironmentObjectDemoView()
                        } label: {
                            DemoLinkLabel(label: "Open @EnvironmentObject Demo", dark: darkModeEnabled)
                        }

                        Divider()

                        // ── Comparison table ───────────────────────────────────
                        NavigationLink {
                            WrapperComparisonView()
                        } label: {
                            DemoLinkLabel(label: "Compare All Wrappers", dark: darkModeEnabled)
                        }
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $showDetailsView) {
                DetailView(
                    isPresented: $showDetailsView,
                    darkModeEnabled: $darkModeEnabled
                )
            }
        }
        // Inject settingsViewModel on the NavigationStack (not its content) so that
        // NavigationLink destinations also inherit it. Applying .environmentObject()
        // inside the stack's content does not propagate to pushed destinations in iOS 16+.
        .environmentObject(settingsViewModel)
    }
}

// ── Small reusable label views (private to this file) ─────────────────────────

private struct SectionHeader: View {
    let title: String
    let dark: Bool

    var body: some View {
        Text(title)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
}

private struct DemoButton: View {
    let label: String
    let dark: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                .clipShape(Capsule())
                .foregroundColor(dark ? .white : .black)
        }
    }
}

private struct DemoLinkLabel: View {
    let label: String
    let dark: Bool

    var body: some View {
        Text(label)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .foregroundColor(dark ? .white : .black)
            .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}

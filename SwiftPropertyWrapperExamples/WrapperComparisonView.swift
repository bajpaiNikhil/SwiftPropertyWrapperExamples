//
//  WrapperComparisonView.swift
//  SwiftPropertyWrapperExamples
//
//  Created by Nikhil Bajpai on 03/03/26.
//
//  A static summary screen comparing all five property wrappers covered in this project.
//  No interactivity — just a reference table to consolidate understanding.
//

import SwiftUI

private struct WrapperRow: Identifiable {
    let id = UUID()
    let wrapper: String
    let ownsData: String
    let howReceived: String
    let survivesRecreate: String
    let bestFor: String
}

struct WrapperComparisonView: View {
    private let rows: [WrapperRow] = [
        WrapperRow(
            wrapper: "@State",
            ownsData: "Yes",
            howReceived: "Local (value type)",
            survivesRecreate: "Yes",
            bestFor: "Simple Bool, Int, String owned by one view"
        ),
        WrapperRow(
            wrapper: "@Binding",
            ownsData: "No",
            howReceived: "Init param ($)",
            survivesRecreate: "N/A — reads parent",
            bestFor: "Child that reads & writes parent's @State"
        ),
        WrapperRow(
            wrapper: "@StateObject",
            ownsData: "Yes",
            howReceived: "Local (reference type)",
            survivesRecreate: "Yes",
            bestFor: "ViewModel owned by a specific view"
        ),
        WrapperRow(
            wrapper: "@ObservedObject",
            ownsData: "No",
            howReceived: "Init param",
            survivesRecreate: "Depends on owner",
            bestFor: "Subscribing to a ViewModel passed from parent"
        ),
        WrapperRow(
            wrapper: "@EnvironmentObject",
            ownsData: "No",
            howReceived: "Environment (implicit)",
            survivesRecreate: "Depends on injector",
            bestFor: "App-wide state without prop drilling"
        ),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("All five wrappers at a glance.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                ForEach(rows) { row in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(row.wrapper)
                            .font(.headline)
                            .foregroundColor(.primary)

                        Group {
                            Label("Owns data: \(row.ownsData)", systemImage: row.ownsData == "Yes" ? "checkmark.circle.fill" : "xmark.circle")
                                .foregroundColor(row.ownsData == "Yes" ? .green : .red)

                            Label("Received via: \(row.howReceived)", systemImage: "arrow.down.circle")

                            Label("Survives recreate: \(row.survivesRecreate)", systemImage: "arrow.clockwise.circle")

                            Label("Best for: \(row.bestFor)", systemImage: "lightbulb")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Compare All Wrappers")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        WrapperComparisonView()
    }
}

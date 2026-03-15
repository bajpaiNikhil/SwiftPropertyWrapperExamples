//
//  AppSettingsViewModel.swift
//  SwiftPropertyWrapperExamples
//
//  Created by Nikhil Bajpai on 03/03/26.
//
//  This is the shared ObservableObject used by all three reference-type wrapper demos.
//  - @StateObject  → a view creates and OWNS an instance of this class
//  - @ObservedObject → a view SUBSCRIBES to an instance passed in from outside
//  - @EnvironmentObject → a view PULLS an instance injected into the SwiftUI environment
//
//  ObservableObject: a protocol that lets SwiftUI know when to re-render views.
//  @Published: marks properties that broadcast changes to every subscribed view.
//

import SwiftUI
import Combine

class AppSettingsViewModel: ObservableObject {
    // Used in the @EnvironmentObject demo — app-wide theme
    @Published var darkModeEnabled: Bool = false

    // Used in the @StateObject demo — owned privately by that screen
    @Published var username: String = "Guest"

    // Used in the @ObservedObject demo — toggled from that screen
    @Published var notificationsEnabled: Bool = true

    // Timestamp recorded at init — used in @StateObject demo to prove
    // the object is only created once, even across multiple re-renders.
    let createdAt: Date = Date()
}

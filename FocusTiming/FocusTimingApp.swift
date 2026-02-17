//
//  FocusTimingApp.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import SwiftUI

@main
struct FocusTimingApp: App {
    
    init() {
        LocalNotificationManager.shared.requestPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

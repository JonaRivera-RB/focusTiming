//
//  RootTabView.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import SwiftUI

struct RootTabView: View {
    
    @StateObject private var dashboardVM = DashboardViewModel()
    @StateObject private var workManager = WorkSessionManager()
    
    let userName: String
    
    var body: some View {
        
        TabView {
            
            // MARK: - Calendario
            
            DashboardView(
                viewModel: dashboardVM,
                userName: userName
            )
            .tabItem {
                Label("Calendario", systemImage: "calendar")
            }
            
            
            // MARK: - Jornada
            
            WorkSessionView(manager: workManager)
                .tabItem {
                    Label("Trabajo", systemImage: "bolt.fill")
                }
        }
    }
}

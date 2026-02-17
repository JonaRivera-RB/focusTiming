//
//  DashboardView.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import SwiftUI

struct DashboardView: View {
    
    @ObservedObject var viewModel: DashboardViewModel
    
    let userName: String
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 24) {
                GreetingHeaderView(userName: userName)
                contentView
            }
            .padding()
        }
        .refreshable {
            viewModel.loadEvents()
        }
        .onAppear {
            if viewModel.state == .idle {
                viewModel.loadEvents()
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        
        switch viewModel.state {
            
        case .loading:
            VStack(spacing: 20) {
                SkeletonCard()
                SkeletonCard()
            }
            
        case .error(let message):
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                
                Text("Ocurrió un error")
                    .font(.headline)
                
                Text(message)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
        case .empty:
            VStack(spacing: 12) {
                Image(systemName: "calendar.badge.exclamationmark")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                
                Text("No hay eventos hoy")
                    .font(.headline)
            }
            
        case .loaded:
            loadedContent
            
        case .idle:
            EmptyView()
        }
    }
    
    
    private var loadedContent: some View {
        VStack(spacing: 24) {
            
            if let current = viewModel.currentEvent {
                EventCardView(
                    title: "Evento actual",
                    eventName: current.summary ?? "",
                    timeLabel: "Transcurrido",
                    timeValue: viewModel.format(viewModel.elapsedTime),
                    style: .active
                )
            }
            
            if let next = viewModel.nextEvent {
                EventCardView(
                    title: "Siguiente reunión",
                    eventName: next.summary ?? "",
                    timeLabel: "Faltan",
                    timeValue: viewModel.format(viewModel.nextEventRemaining),
                    style: .upcoming
                )
            }
            
            if !viewModel.upcomingEvents.isEmpty {
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Próximos eventos")
                        .font(.headline)
                    
                    ForEach(viewModel.upcomingEvents.prefix(3), id: \.id) { event in
                        UpcomingEventRow(
                            title: event.summary ?? "",
                            time: event.start.dateTime ?? ""
                        )
                    }
                }
            }
        }
    }
}

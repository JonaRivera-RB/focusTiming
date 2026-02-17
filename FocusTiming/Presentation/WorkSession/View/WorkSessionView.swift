//
//  WorkSessionView.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import SwiftUI

struct EditableTask: Identifiable {
    let id = UUID()
    var title: String = ""
    var duration: Double = 1
    var unit: TimeUnit = .hours
}

enum TimeUnit: String, CaseIterable {
    case minutes = "Min"
    case hours = "Horas"
}


struct WorkSessionView: View {
    
    @ObservedObject var manager: WorkSessionManager
    
    @State private var showFinishAlert = false
    @State private var inputText = "2,2,2,2"
    
    @State private var tasks: [EditableTask] = [
        EditableTask()
    ]

    var body: some View {
        
        VStack(spacing: 24) {
            
            if manager.session == nil {
                setupView
            } else {
                activeSessionView
            }
        }
        .padding()
        .onAppear {
            manager.restoreSession()
        }
    }
}

private extension WorkSessionView {
    
    var setupView: some View {
        
        ScrollView {
            VStack(spacing: 24) {
                
                Text("Iniciar jornada")
                    .font(.largeTitle.bold())
                
                VStack(spacing: 16) {
                    
                    ForEach($tasks) { $task in
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            TextField("Nombre de la tarea",
                                      text: $task.title)
                                .textFieldStyle(.roundedBorder)
                            
                            HStack {
                                
                                TextField("Duración",
                                          value: $task.duration,
                                          format: .number)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(.roundedBorder)
                                
                                Picker("", selection: $task.unit) {
                                    ForEach(TimeUnit.allCases, id: \.self) {
                                        Text($0.rawValue)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .frame(width: 140)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(16)
                    }
                }
                
                Button {
                    tasks.append(EditableTask())
                } label: {
                    Label("Agregar tarea", systemImage: "plus")
                }
                
                Button("Comenzar jornada") {
                    
                    let formattedTasks: [(title: String, hours: Double)] = tasks.compactMap { task in
                        
                        guard !task.title.isEmpty else { return nil }
                        
                        let hours: Double
                        
                        switch task.unit {
                        case .minutes:
                            hours = task.duration / 60
                        case .hours:
                            hours = task.duration
                        }
                        
                        return (title: task.title, hours: hours)
                    }
                    
                    manager.startSession(tasks: formattedTasks)
                }
                .buttonStyle(.borderedProminent)
                .disabled(tasks.isEmpty)
            }
            .padding()
        }
    }
}

private extension WorkSessionView {
    
    var activeSessionView: some View {
        
        ScrollView {
            VStack(spacing: 32) {
                
                if let session = manager.session {
                    
                    // 🔵 Círculo principal
                    FocusCircleView(
                        progress: manager.blockProgress,
                        timeString: formatTime(manager.elapsedTime),
                        taskName: manager.currentBlock?.title ?? "Sin bloque activo",
                        blockIndex: (manager.currentBlockIndex ?? 0) + 1,
                        totalBlocks: session.blocks.count
                    )
                    
                    // 🟣 Progreso del día
                    DayProgressView(progress: manager.totalProgress)
                    
                    // 🟢 Lista de bloques
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("Bloques de hoy")
                            .font(.headline)
                        
                        ForEach(session.blocks.indices, id: \.self) { index in
                            
                            let block = session.blocks[index]
                            
                            WorkBlockRow(
                                title: block.title,
                                durationHours: block.duration / 3600,
                                isActive: manager.currentBlockIndex == index,
                                isCompleted: index < (manager.currentBlockIndex ?? 0)
                            )
                        }
                    }
                    
                    // 🔴 Finalizar
                    Button("Finalizar jornada") {
                        showFinishAlert = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            }
            .padding()
        }
        .alert("Finalizar sesión",
               isPresented: $showFinishAlert) {
            
            Button("Cancelar", role: .cancel) {}
            
            Button("Finalizar", role: .destructive) {
                manager.reset()
            }
        }
    }
}

private extension WorkSessionView {
    
    func formatTime(_ interval: TimeInterval) -> String {
        
        let totalSeconds = Int(interval)
        
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

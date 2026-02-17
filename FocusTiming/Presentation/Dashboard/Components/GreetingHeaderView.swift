//
//  GreetingHeaderView.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import SwiftUI

struct GreetingHeaderView: View {
    
    let userName: String
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12: return "Buenos días"
        case 12..<19: return "Buenas tardes"
        default: return "Buenas noches"
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(greeting),")
                    .font(AppTypography.greeting)
                    .foregroundColor(AppColors.secondaryText)
                
                Text(userName)
                    .font(AppTypography.userName)
            }
            
            Spacer()
            
            HStack(spacing: 18) {
                Image(systemName: "clock")
                Image(systemName: "bell")
            }
            .font(.title3)
        }
    }
}

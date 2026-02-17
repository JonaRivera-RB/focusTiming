//
//  GlassCard.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import SwiftUI

struct GlassCard<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(AppSpacing.cardPadding)
            .background(.ultraThinMaterial)
            .cornerRadius(28)
    }
}

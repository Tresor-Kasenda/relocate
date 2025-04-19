//
//  ContentView.swift
//  relocation
//
//  Created by Tresor KASENDA on 12/04/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isActive = true
    
    var body: some View {
        ZStack {
            if isActive {
                SplashScreen()
                    .transition(.opacity)
                    .animation(.easeOut, value: isActive)
            } else {
                Login()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeOut(duration: 0.5)) {
                    self.isActive = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

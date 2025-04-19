//
//  SplashScreen.swift
//  relocation
//
//  Created by Tresor KASENDA on 13/04/2025.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color(hex: "F5F0EB")
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("RELOCATION")
                    .font(.system(
                        size: 40,
                        weight: .bold
                    ))
                    .foregroundColor(.black.opacity(0.80))
                Spacer()
                Text("Relocation")
                    .font(.title)
                    .foregroundColor(Color.gray.opacity(0.80))
                    .fontWeight(.semibold)
                    .padding(.bottom, 40)
            }
        }
    }
}

extension Color {
    init(hex: String, alpha: Double = 1.0) {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.hasPrefix("#")
                ? String(hexSanitized.dropFirst())
                : hexSanitized

            var rgb: UInt64 = 0
            Scanner(string: hexSanitized).scanHexInt64(&rgb)

            let r = Double((rgb & 0xFF0000) >> 16) / 255.0
            let g = Double((rgb & 0x00FF00) >> 8) / 255.0
            let b = Double( rgb & 0x0000FF       ) / 255.0

            self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
        }
}

#Preview {
    SplashScreen()
}

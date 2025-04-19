//
//  DiscoverCard.swift
//  relocation
//
//  Created by Tresor KASENDA on 12/04/2025.
//

import SwiftUI

struct DiscoverCard: View {
    var body: some View {
        VStack(spacing: 10) {
            Image("Image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .frame(height: 200)
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Daniasyrofi Fruit Shop")
                        .font(.title3)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                    
                    HStack(alignment: .center) {
                        // Rating
                        HStack(alignment: .center) {
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.yellow)
                            Text("4,9 (201)")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.leading, 5)
                        }
                        
                        // Divider
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 1, height: 25)
                        
                        // Distance
                        HStack(alignment: .center) {
                            Image(systemName: "location")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.blue)
                            Text("3km")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.leading, 5)
                        }
                    }
                }
                
                Spacer()
                
                // Favorite Button
                Button {
                    // Action
                } label: {
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .scaledToFill()
                        .foregroundColor(.black)
                }
                .padding(12)
                .background(.gray.opacity(0.2))
                .clipShape(Circle())
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

#Preview {
    DiscoverCard()
}

import SwiftUI

struct LocationDetailsView: View {
    let annotation: LocationAnnotation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Circle()
                    .fill(annotationColor(for: annotation.type))
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: annotationIcon(for: annotation.type))
                            .foregroundColor(.white)
                    }
                
                VStack(alignment: .leading) {
                    Text(locationTitle(for: annotation.type))
                        .font(.headline)
                    Text("Location: \(annotation.coordinate.latitude), \(annotation.coordinate.longitude)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            Divider()
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                InfoRow(icon: "mappin.circle.fill", title: "Address", text: "123 Sample Street")
                InfoRow(icon: "clock.fill", title: "Available", text: "9:00 AM - 5:00 PM")
                InfoRow(icon: "star.fill", title: "Rating", text: "4.5/5")
            }
            .padding()
            
            Spacer()
        }
    }
    
    private func annotationColor(for type: LocationAnnotation.AnnotationType) -> Color {
        switch type {
        case .user: return .blue
        case .station: return .red
        case .special: return .yellow
        }
    }
    
    private func annotationIcon(for type: LocationAnnotation.AnnotationType) -> String {
        switch type {
        case .user: return "person.fill"
        case .station: return "building.2.fill"
        case .special: return "star.fill"
        }
    }
    
    private func locationTitle(for type: LocationAnnotation.AnnotationType) -> String {
        switch type {
        case .user: return "User Location"
        case .station: return "Station"
        case .special: return "Special Location"
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(text)
                    .font(.body)
            }
        }
    }
}
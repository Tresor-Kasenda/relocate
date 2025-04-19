import SwiftUI

struct RoleSelectionView: View {
    @Binding var userRole: UserRole?
    
    enum UserRole {
        case resident
        case newcomer
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Choose Your Role")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Are you a resident or new to the city?")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 16) {
                RoleButton(
                    title: "City Resident",
                    subtitle: "I already live in the city",
                    icon: "house.fill",
                    isSelected: userRole == .resident
                ) {
                    userRole = .resident
                }
                
                RoleButton(
                    title: "New to City",
                    subtitle: "I'm planning to move here",
                    icon: "airplane.arrival",
                    isSelected: userRole == .newcomer
                ) {
                    userRole = .newcomer
                }
            }
        }
    }
}

#Preview(){
    RoleSelectionView(userRole: .constant(nil))
}

private struct RoleButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color.white)
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}

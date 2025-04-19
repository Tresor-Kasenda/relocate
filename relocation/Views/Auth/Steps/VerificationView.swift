import SwiftUI
import PhotosUI

struct VerificationView: View {
    let isResident: Bool
    @Binding var currentLocation: String
    @Binding var showingMap: Bool
    @Binding var idImage: Image?
    @Binding var showingImageOptions: Bool
    @Binding var isShowingCamera: Bool
    @Binding var selectedIDImage: PhotosPickerItem?
    @Binding var showPhotoPicker: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Text(isResident ? "Resident Verification" : "Newcomer Information")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                LocationSelector(
                    currentLocation: $currentLocation,
                    showingMap: $showingMap
                )
                
                IDDocumentPicker(
                    idImage: $idImage,
                    showingImageOptions: $showingImageOptions,
                    isShowingCamera: $isShowingCamera,
                    selectedIDImage: $selectedIDImage,
                    showPhotoPicker: $showPhotoPicker
                )
            }
        }
    }
}

private struct LocationSelector: View {
    @Binding var currentLocation: String
    @Binding var showingMap: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Current Location")
                .foregroundColor(.gray)
            Button(action: {
                showingMap = true
            }) {
                HStack {
                    Text(currentLocation.isEmpty ? "Select your location" : currentLocation)
                        .foregroundColor(currentLocation.isEmpty ? .gray : .black)
                    Spacer()
                    Image(systemName: "map")
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(14)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
        }
    }
}
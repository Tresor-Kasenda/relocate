//
//  SignUp.swift
//  relocation
//
//  Created by Tresor KASENDA on 12/04/2025.
//

import SwiftUI
import PhotosUI
import CoreLocation
import MapKit
import AVFoundation

struct SignUp: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var locationManager = LocationManager()
    @State private var currentStep = 0
    @State private var userRole: RoleSelectionView.UserRole?
    @State private var showingMap = false
    @State private var showingImageOptions = false
    @State private var showOTPVerification = false
    @State private var showPhotoPicker = false
    
    // OTP Fields
    @State private var otpFields = Array(repeating: "", count: 6)
    @State private var currentOTPField = 0
    
    // Personal Info
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    // Location Info
    @State private var selectedCity = ""
    @State private var currentLocation = ""
    @State private var selectedIDImage: PhotosPickerItem? = nil
    @State private var idImage: Image?
    @State private var idUIImage: UIImage?
    @State private var isShowingCamera = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "F5F0EB")
                    .ignoresSafeArea()
                
                VStack {
                    ProgressBar(currentStep: currentStep)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            switch currentStep {
                            case 0:
                                RoleSelectionView(userRole: $userRole)
                            case 1:
                                PersonalInfoView(
                                    firstName: $firstName,
                                    lastName: $lastName,
                                    email: $email,
                                    password: $password,
                                    confirmPassword: $confirmPassword
                                )
                            case 2:
                                VerificationView(
                                    isResident: userRole == .resident,
                                    currentLocation: $currentLocation,
                                    showingMap: $showingMap,
                                    idImage: $idImage,
                                    showingImageOptions: $showingImageOptions,
                                    isShowingCamera: $isShowingCamera,
                                    selectedIDImage: $selectedIDImage,
                                    showPhotoPicker: $showPhotoPicker
                                )
                            case 3:
                                OTPVerificationView(
                                    otpFields: $otpFields,
                                    currentOTPField: $currentOTPField
                                )
                            default:
                                EmptyView()
                            }
                        }
                        .padding()
                    }
                    
                    NavigationButtons(
                        currentStep: $currentStep,
                        showSuccess: Binding.constant(false),
                        canProceed: currentStep == 0 ? userRole != nil : true,
                        personalInfoView: PersonalInfoView(
                            firstName: $firstName,
                            lastName: $lastName,
                            email: $email,
                            password: $password,
                            confirmPassword: $confirmPassword
                        ),
                        otpVerificationView: OTPVerificationView(
                            otpFields: $otpFields,
                            currentOTPField: $currentOTPField
                        )
                    )
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(isPresented: $showingMap) {
                LocationPickerView(location: $currentLocation, showingMap: $showingMap)
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $isShowingCamera) {
                CameraView(image: $idUIImage, idImage: $idImage)
            }
            .photosPicker(isPresented: $showPhotoPicker, selection: $selectedIDImage, matching: .images)
            .onChange(of: selectedIDImage) { oldValue, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        idImage = Image(uiImage: uiImage)
                        idUIImage = uiImage
                    }
                }
            }
            .actionSheet(isPresented: $showingImageOptions) {
                ActionSheet(
                    title: Text("Select Image"),
                    message: Text("Choose a source"),
                    buttons: [
                        .default(Text("Camera")) {
                            isShowingCamera = true
                        },
                        .default(Text("Photo Library")) {
                            showPhotoPicker = true
                        },
                        .cancel()
                    ]
                )
            }
        }
    }
}

private struct ProgressBar: View {
    let currentStep: Int
    
    var body: some View {
        HStack {
            ForEach(0..<4) { step in
                Capsule()
                    .fill(currentStep >= step ? Color(hex: "2f1e1b") : Color.gray.opacity(0.3))
                    .frame(height: 4)
            }
        }
    }
}

private struct NavigationButtons: View {
    @Binding var currentStep: Int
    @Binding var showSuccess: Bool
    let canProceed: Bool
    var personalInfoView: PersonalInfoView
    var otpVerificationView: OTPVerificationView
    
    var body: some View {
        VStack(spacing: 16) {
            if currentStep > 0 {
                Button(action: {
                    withAnimation {
                        currentStep -= 1
                    }
                }) {
                    Text("Previous")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(14)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
            }
            
            NavigationLink(destination: SuccessView()) {
                Text(currentStep == 3 ? "Verify Account" : "Next")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(14)
            }
            .opacity(currentStep == 3 && otpVerificationView.isOTPValid ? 1 : 0)
            .disabled(currentStep != 3 || !otpVerificationView.isOTPValid)
            
            if currentStep != 3 {
                Button(action: {
                    if currentStep == 0 && canProceed {
                        withAnimation {
                            currentStep += 1
                        }
                    } else if currentStep == 1 && personalInfoView.isFormValid {
                        withAnimation {
                            currentStep += 1
                        }
                    } else if currentStep == 2 {
                        withAnimation {
                            currentStep += 1
                        }
                    }
                }) {
                    Text("Next")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            (currentStep == 0 && !canProceed) ||
                            (currentStep == 1 && !personalInfoView.isFormValid)
                            ? Color.gray
                            : Color(hex: "2f1e1b")
                        )
                        .cornerRadius(14)
                }
                .disabled((currentStep == 0 && !canProceed) ||
                         (currentStep == 1 && !personalInfoView.isFormValid))
            }
        }
        .padding()
        .background(Color(hex: "F5F0EB"))
    }
}

// Existing code ...

struct IDDocumentPicker: View {
    @Binding var idImage: Image?
    @Binding var showingImageOptions: Bool
    @Binding var isShowingCamera: Bool
    @Binding var selectedIDImage: PhotosPickerItem?
    @Binding var showPhotoPicker: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Identity Document")
                .foregroundColor(.gray)
            
            Button(action: {
                showingImageOptions = true
            }) {
                if let idImage {
                    idImage
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(14)
                } else {
                    VStack {
                        Image(systemName: "doc.badge.plus")
                            .font(.system(size: 40))
                        Text("Upload ID Document")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background(Color.white)
                    .cornerRadius(14)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
            }
        }
    }
}

struct SuccessView: View {
    @State private var navigateToHome = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color(hex: "F5F0EB")
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.green)
                        
                        Text("Account Created Successfully!")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Your account has been verified and created successfully. Welcome to RELOCATION!")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: HomePage(), isActive: $navigateToHome) {
                        Button(action: {
                            navigateToHome = true
                        }) {
                            Text("Start Exploring")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(14)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}

// LocationManager pour gérer la géolocalisation
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}

// Vue pour la sélection de localisation
struct LocationPickerView: View {
    @Binding var location: String
    @Binding var showingMap: Bool
    @StateObject private var locationManager = LocationManager()
    @State private var searchText = ""
    @State private var selectedPin: MKPlacemark?
    @State private var position: MapCameraPosition = .automatic
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(position: $position)
                    .ignoresSafeArea()
                    .mapControls {
                        MapUserLocationButton()
                        MapCompass()
                        MapScaleView()
                    }
                
                if let selectedPin = selectedPin {
                    VStack {
                        Spacer()
                        Button(action: {
                            location = selectedPin.title ?? "Selected Location"
                            showingMap = false
                        }) {
                            Text("Confirm Location")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(14)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Select Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingMap = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Use Current") {
                        locationManager.requestLocation()
                    }
                }
            }
            .onChange(of: locationManager.location) { oldValue, newValue in
                if let location = newValue {
                    position = .region(MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    ))
                }
            }
        }
    }
}

// Vue pour la caméra
struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var idImage: Image?
    @Environment(\.presentationMode) private var presentationMode
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
                parent.idImage = Image(uiImage: image)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentationMode.wrappedValue.dismiss()
            return picker
        }
        
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                DispatchQueue.main.async {
                    picker.sourceType = .camera
                    picker.cameraCaptureMode = .photo
                    picker.modalPresentationStyle = .fullScreen
                }
            } else {
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// Existing code ...
class NavigationCoordinator: ObservableObject {
    @Published var showHomePage = false
    
    func navigateToHome() {
        showHomePage = true
    }
}

#Preview {
    SignUp()
}

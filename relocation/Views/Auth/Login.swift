//
//  Login.swift
//  relocation
//
//  Created by Tresor KASENDA on 12/04/2025.
//

import SwiftUI

struct Login: View {
    @State private var email = ""
    @State private var password = ""
    @State private var navigateToSignup = false
    @State private var isPasswordVisible = false
    @State private var isLoading = false
    @EnvironmentObject private var navigationCoordinator: NavigationCoordinator
    
    @State private var emailError = ""
    @State private var passwordError = ""
    
    private func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        if email.isEmpty {
            emailError = "Email is required"
            return false
        } else if !emailPredicate.evaluate(with: email) {
            emailError = "Please enter a valid email"
            return false
        }
        emailError = ""
        return true
    }
    
    private func validatePassword() -> Bool {
        if password.isEmpty {
            passwordError = "Password is required"
            return false
        }
        passwordError = ""
        return true
    }
    
    private var isFormValid: Bool {
        validateEmail() && validatePassword()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "F5F0EB")
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack(spacing: 15) {
                        Image(systemName: "cube.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                        
                        Text("Welcome to RELOCATION! 👋")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Don't miss the opportunity to easily find your\ndream home at RELOCATION!")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 60)
                    
                    VStack(spacing: 18) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Email")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            TextField("Enter your email", text: $email)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(14)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(emailError.isEmpty ? Color.clear : Color.red, lineWidth: 1)
                                )
                            if !emailError.isEmpty {
                                Text(emailError)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Password")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            HStack {
                                if isPasswordVisible {
                                    TextField("Enter your password", text: $password)
                                } else {
                                    SecureField("Enter your password", text: $password)
                                }
                                
                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(14)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(passwordError.isEmpty ? Color.clear : Color.red, lineWidth: 1)
                            )
                            if !passwordError.isEmpty {
                                Text(passwordError)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                        
                        Button(action: {
                            if isFormValid {
                                isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    print("\(email), \(password)")
                                    isLoading = false
                                }
                            }
                        }) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .padding(.trailing, 5)
                                }
                                Text("Sign In")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "2f1e1b"))
                            .cornerRadius(14)
                        }
                        .disabled(!isFormValid || isLoading)
                        
                        Button {
                            navigateToSignup = true
                        } label: {
                            HStack(alignment: .center){
                                Text("Don't have an account?")
                                    .foregroundColor(.gray)
                                Text("Sign Up")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Text("OR")
                        .foregroundColor(.gray)
                        .padding(.vertical)
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            // Action pour Apple Sign In
                        }) {
                            HStack(alignment: .center) {
                                Image(systemName: "apple.logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(Color(hex: "2f1e1b"))
                                Text("Continue with Apple")
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hex: "2f1e1b"))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white)
                            .cornerRadius(14)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                        
                        Button(action: {
                            // Action pour Google Sign In
                        }) {
                            HStack(alignment: .center) {
                                Image(systemName: "g.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(Color(hex: "2f1e1b"))
                                Text("Continue with Google")
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(hex: "2f1e1b"))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white)
                            .cornerRadius(14)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    VStack {
                        Text("By continuing, you agree to RELOCATION ")
                            .font(.caption)
                            .foregroundColor(.gray) +
                        Text("Terms of Service")
                            .font(.caption)
                            .foregroundColor(.blue) +
                        Text(" and ")
                            .font(.caption)
                            .foregroundColor(.gray) +
                        Text("Privacy Policy")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 20)
                }
                .padding()
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToSignup) {
                SignUp()
            }
        }
    }
}

#Preview {
    Login()
}

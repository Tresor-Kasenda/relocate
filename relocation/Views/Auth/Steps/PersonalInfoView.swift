import SwiftUI

struct PersonalInfoView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    
    @State private var firstNameError = ""
    @State private var lastNameError = ""
    @State private var emailError = ""
    @State private var passwordError = ""
    @State private var confirmPasswordError = ""
    
    private func validateFirstName() {
        if firstName.isEmpty {
            firstNameError = "First name is required"
        } else if firstName.count < 2 {
            firstNameError = "First name must be at least 2 characters"
        } else {
            firstNameError = ""
        }
    }
    
    private func validateLastName() {
        if lastName.isEmpty {
            lastNameError = "Last name is required"
        } else if lastName.count < 2 {
            lastNameError = "Last name must be at least 2 characters"
        } else {
            lastNameError = ""
        }
    }
    
    private func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        if email.isEmpty {
            emailError = "Email is required"
        } else if !emailPredicate.evaluate(with: email) {
            emailError = "Please enter a valid email"
        } else {
            emailError = ""
        }
    }
    
    private func validatePassword() {
        if password.isEmpty {
            passwordError = "Password is required"
        } else if password.count < 8 {
            passwordError = "Password must be at least 8 characters"
        } else {
            passwordError = ""
        }
    }
    
    private func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordError = "Please confirm your password"
        } else if confirmPassword != password {
            confirmPasswordError = "Passwords do not match"
        } else {
            confirmPasswordError = ""
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Personal Information")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                CustomTextField(
                    title: "First Name",
                    placeholder: "Enter your first name",
                    text: $firstName,
                    errorMessage: firstNameError
                )
                .onChange(of: firstName) { _, _ in
                    validateFirstName()
                }
                
                CustomTextField(
                    title: "Last Name",
                    placeholder: "Enter your last name",
                    text: $lastName,
                    errorMessage: lastNameError
                )
                .onChange(of: lastName) { _, _ in
                    validateLastName()
                }
                
                CustomTextField(
                    title: "Email",
                    placeholder: "Enter your email",
                    text: $email,
                    errorMessage: emailError
                )
                .onChange(of: email) { _, _ in
                    validateEmail()
                }
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                
                CustomSecureField(
                    title: "Password",
                    placeholder: "Create a password",
                    text: $password,
                    errorMessage: passwordError
                )
                .onChange(of: password) { _, _ in
                    validatePassword()
                }
                
                CustomSecureField(
                    title: "Confirm Password",
                    placeholder: "Confirm your password",
                    text: $confirmPassword,
                    errorMessage: confirmPasswordError
                )
                .onChange(of: confirmPassword) { _, _ in
                    validateConfirmPassword()
                }
            }
        }
    }
    
    var isFormValid: Bool {
        validateFirstName()
        validateLastName()
        validateEmail()
        validatePassword()
        validateConfirmPassword()
        
        return firstNameError.isEmpty && 
               lastNameError.isEmpty && 
               emailError.isEmpty && 
               passwordError.isEmpty && 
               confirmPasswordError.isEmpty
    }
}

private struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let errorMessage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.gray)
            TextField(placeholder, text: $text)
                .padding()
                .background(Color.white)
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(errorMessage.isEmpty ? Color.clear : Color.red, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

private struct CustomSecureField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let errorMessage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.gray)
            SecureField(placeholder, text: $text)
                .padding()
                .background(Color.white)
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(errorMessage.isEmpty ? Color.clear : Color.red, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

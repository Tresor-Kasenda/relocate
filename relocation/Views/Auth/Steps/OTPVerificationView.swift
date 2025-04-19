import SwiftUI

struct OTPVerificationView: View {
    @Binding var otpFields: [String]
    @Binding var currentOTPField: Int
    @State private var otpError = ""
    
    // ADD: Focus state for each field
    @FocusState private var focusedField: Int?
    
    private func validateOTP() {
        let otp = otpFields.joined()
        if otp.count != 6 {
            otpError = "Please enter all 6 digits"
        } else if !otp.allSatisfy({ $0.isNumber }) {
            otpError = "OTP must contain only numbers"
        } else {
            otpError = ""
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Verify Your Account")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Enter the verification code sent to your email")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    ForEach(0..<6, id: \.self) { index in
                        TextField("", text: $otpFields[index])
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .frame(width: 45, height: 55)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            .focused($focusedField, equals: index)
                            .onChange(of: otpFields[index]) { oldValue, newValue in
                                // Validate input is number
                                if !newValue.isEmpty && !newValue.allSatisfy({ $0.isNumber }) {
                                    otpFields[index] = oldValue
                                    return
                                }
                                
                                // Limit to single digit
                                if newValue.count > 1 {
                                    let currentDigit = String(newValue.prefix(1))
                                    otpFields[index] = currentDigit
                                    
                                    // If there are more digits, try to fill next fields
                                    if newValue.count > 1 {
                                        let remainingDigits = Array(newValue.dropFirst())
                                        for (offset, digit) in remainingDigits.enumerated() {
                                            let nextIndex = index + offset + 1
                                            if nextIndex < 6 {
                                                otpFields[nextIndex] = String(digit)
                                            }
                                        }
                                    }
                                }
                                
                                // Auto-advance to next field
                                if newValue.count == 1 && index < 5 {
                                    focusedField = index + 1
                                }
                                
                                // Handle backspace to previous field
                                if newValue.isEmpty && index > 0 {
                                    focusedField = index - 1
                                }
                                
                                validateOTP()
                            }
                    }
                }
                .onAppear {
                    // Focus first field when view appears
                    focusedField = 0
                }
                
                if !otpError.isEmpty {
                    Text(otpError)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            Button(action: {
                // Resend OTP action
            }) {
                Text("Didn't receive code? Resend")
                    .foregroundColor(.blue)
                    .font(.subheadline)
            }
        }
    }
    
    var isOTPValid: Bool {
        validateOTP()
        return otpError.isEmpty
    }
}

private struct OTPFieldsView: View {
    @Binding var otpFields: [String]
    @Binding var currentField: Int
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<6) { index in
                TextField("", text: $otpFields[index])
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width: 45, height: 55)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .onChange(of: otpFields[index]) { oldValue, newValue in
                        if !newValue.isEmpty && !newValue.allSatisfy({ $0.isNumber }) {
                            otpFields[index] = oldValue
                            return
                        }
                        
                        if newValue.count > 1 {
                            otpFields[index] = String(newValue.prefix(1))
                        }
                        if newValue.count == 1 && index < 5 {
                            currentField = index + 1
                        }
                        if newValue.count == 0 && index > 0 {
                            currentField = index - 1
                        }
                    }
            }
        }
        .padding(.vertical, 20)
    }
}

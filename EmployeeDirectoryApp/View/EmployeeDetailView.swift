//
//  EmployeeDetailView.swift
//  EmployeeDirectoryApp
//
//  Created by Twinkle on 2022-04-05.
//

import SwiftUI

struct EmployeeDetailView: View {
    @StateObject private var viewModel = EmployeeListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading && viewModel.employees.isEmpty {
                    ProgressView()
                } else {
                    List(viewModel.employees) { employee in
                        EmployeeListView(employee: employee)
                    }
                    .refreshable {
                        viewModel.refreshEmployees()
                    }
                }
            }
            .navigationBarTitle("Employee Directory")
        }
    }
}

struct EmployeeListView: View {
    let employee: Employee
    @State private var showFullScreenImage = false
    
    var body: some View {
        NavigationLink(destination: EmployeeFullDetailView(employee: employee)) {
            HStack(alignment: .top) {
                EmployeeImageView(urlString: employee.photoUrlSmall)
                    .onTapGesture {
                        showFullScreenImage = true
                    }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(employee.fullName ?? "Unknown Name")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .underline()
                    
                    if let phoneNumber = employee.phoneNumber {
                        Button(action: {
                            if let phoneURL = URL(string: "tel://\(phoneNumber)") {
                                UIApplication.shared.open(phoneURL)
                            }
                        }) {
                            HStack(spacing: 4) {
                                Text(phoneNumber)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                Image(systemName: "phone.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    if let team = employee.team {
                        Text(team)
                            .font(.subheadline)
                    }
                    
                    if let email = employee.emailAddress {
                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    
                    if let biography = employee.biography {
                        Text(biography)
                            .font(.subheadline)
                            .fontWeight(.thin)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showFullScreenImage) {
            FullScreenImageView(urlString: employee.photoUrlLarge)
        }
    }
}

struct EmployeeFullDetailView: View {
    let employee: Employee
    @State private var showFullScreenImage = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                // Large Image
                EmployeeImageView(urlString: employee.photoUrlLarge, frameSize: 200)
                    .onTapGesture {
                        showFullScreenImage = true
                    }
                    .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 16) {
                    // Name
                    Text(employee.fullName ?? "Unknown Name")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    // Team
                    if let team = employee.team {
                        EmployeeDetailRow(
                            icon: "person.3.fill",
                            title: "Team",
                            content: team
                        )
                    }
                    
                    // Employee Type
                    if let employeeType = employee.employeeType {
                        EmployeeDetailRow(
                            icon: "briefcase.fill",
                            title: "Type",
                            content: employeeType
                        )
                    }
                    
                    // Phone
                    if let phoneNumber = employee.phoneNumber {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Phone")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Button(action: {
                                    if let phoneURL = URL(string: "tel://\(phoneNumber)") {
                                        UIApplication.shared.open(phoneURL)
                                    }
                                }) {
                                    Text(phoneNumber)
                                        .font(.body)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // Email
                    if let email = employee.emailAddress {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Email")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Button(action: {
                                    if let emailURL = URL(string: "mailto:\(email)") {
                                        UIApplication.shared.open(emailURL)
                                    }
                                }) {
                                    Text(email)
                                        .font(.body)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // Biography
                    if let biography = employee.biography {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(biography)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarTitle("Employee Details", displayMode: .inline)
        .sheet(isPresented: $showFullScreenImage) {
            FullScreenImageView(urlString: employee.photoUrlLarge)
        }
    }
}

struct EmployeeDetailRow: View {
    let icon: String
    let title: String
    let content: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(content)
                    .font(.body)
                    .foregroundColor(.primary)
            }
        }
        .padding(.vertical, 8)
    }
}

struct FullScreenImageView: View {
    let urlString: String?
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: EmployeeImageViewModel
    
    init(urlString: String?) {
        self.urlString = urlString
        _viewModel = StateObject(wrappedValue: EmployeeImageViewModel(urlString: urlString))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                Group {
                    if let image = viewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "photo.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white.opacity(0.5))
                            Text("Image not available")
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

struct EmployeeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeDetailView()
    }
}

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
    
    var body: some View {
        HStack(alignment: .top) {
            EmployeeImageView(urlString: employee.photoUrlSmall)
            VStack(alignment: .leading, spacing: 4) {
                Text(employee.fullName ?? "Unknown Name")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .underline()
                
                if let phoneNumber = employee.phoneNumber {
                    Text(phoneNumber)
                        .font(.subheadline)
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
}

struct EmployeeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeDetailView()
    }
}

//
//  EmployeeListViewModel.swift
//  EmployeeDirectoryApp
//
//  Created by Twinkle on 2022-04-05.
//

import Foundation

class EmployeeListViewModel: ObservableObject {
    @Published var employees: [Employee] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let urlBase = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
    
    init() {
        loadEmployees()
    }
    
    func loadEmployees() {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: urlBase) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                self?.parseEmployees(from: data)
            }
        }
        
        task.resume()
    }
    
    func refreshEmployees() {
        employees.removeAll()
        loadEmployees()
    }
    
    private func parseEmployees(from data: Data) {
        do {
            let response = try JSONDecoder().decode(EmployeeAPIResponse.self, from: data)
            let sortedEmployees = (response.employees ?? []).sorted { 
                ($0.fullName ?? "") < ($1.fullName ?? "") 
            }
            employees = sortedEmployees
        } catch {
            print("Error parsing JSON: \(error)")
            errorMessage = "Failed to parse employee data"
        }
    }
}


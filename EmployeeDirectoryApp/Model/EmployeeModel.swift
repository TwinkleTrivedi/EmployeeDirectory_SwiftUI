//
//  EmployeeModel.swift
//  EmployeeDirectoryApp
//
//  Created by Twinkle on 2022-04-05.
//

import Foundation

class EmployeeModel: ObservableObject, RandomAccessCollection {
    
    @Published var employeeDetails = [EmployeeDetails]()
    
    var startIndex: Int { employeeDetails.startIndex }
    var endIndex: Int { employeeDetails.endIndex }
    
    var urlBase = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
    
    init() {
        loadMoreEmployees()
    }
    
    subscript(position: Int) -> EmployeeDetails {
        return employeeDetails[position]
    }
    
    func loadMoreEmployees(currentItem: EmployeeDetails? = nil) {
        let urlString = "\(urlBase)"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: parseEmployeeDetailsFromResponse(data:response:error:))
        task.resume()
    }

    func parseEmployeeDetailsFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            return
        }
        guard let data = data else {
            return
        }
        
        let Employee = parseEmployeeDetailsFromData(data: data)
        let sortedEmployees = Employee.sorted { $0.full_name ?? "" < $1.full_name ?? ""}
        DispatchQueue.main.async {
            self.employeeDetails.append(contentsOf: sortedEmployees)
        }
    }
    
    func parseEmployeeDetailsFromData(data: Data) -> [EmployeeDetails] {
        var response: EmpoyeeApiResponse
        do {
            response = try JSONDecoder().decode(EmpoyeeApiResponse.self, from: data)
        } catch {
            print("Error parsing the JSON: \(error)")
            return []
        }
        
        return response.employees ?? []
    }
}

class EmpoyeeApiResponse: Codable {
    var employees: [EmployeeDetails]?
}

class EmployeeDetails: Identifiable, Codable {
    var full_name: String?
    var phone_number: String?
    var email_address: String?
    var biography: String?
    var photo_url_small: String?
    var team: String?
    var employee_type: String?
    var photo_url_large: String?
    var uuid: String?
}


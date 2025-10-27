//
//  EmployeeModel.swift
//  EmployeeDirectoryApp
//
//  Created by Twinkle on 2022-04-05.
//

import Foundation

// MARK: - API Response Model
struct EmployeeAPIResponse: Codable {
    let employees: [Employee]?
}

// MARK: - Employee Data Model
struct Employee: Identifiable, Codable {
    let fullName: String?
    let phoneNumber: String?
    let emailAddress: String?
    let biography: String?
    let photoUrlSmall: String?
    let team: String?
    let employeeType: String?
    let photoUrlLarge: String?
    let uuid: String?
    
    var id: String {
        uuid ?? UUID().uuidString
    }
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case emailAddress = "email_address"
        case biography
        case photoUrlSmall = "photo_url_small"
        case team
        case employeeType = "employee_type"
        case photoUrlLarge = "photo_url_large"
        case uuid
    }
}


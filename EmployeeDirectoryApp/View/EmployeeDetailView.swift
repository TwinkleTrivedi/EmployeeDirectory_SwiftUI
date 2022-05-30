//
//  EmployeeDetailView.swift
//  EmployeeDirectoryApp
//
//  Created by Twinkle on 2022-04-05.
//

import SwiftUI

struct EmployeeDetailView: View {
    @ObservedObject var employeeModel = EmployeeModel()
    
    var body: some View {
        NavigationView {
            List(employeeModel) { (employees: EmployeeDetails) in
                EmployeeListView(employees: employees)
            }
        .navigationBarTitle("Employee Directory")
        }
        .refreshable {
            employeeModel.employeeDetails.removeAll()
            employeeModel.loadMoreEmployees()
        }

    }
}


struct EmployeeListView: View {
    var employees: EmployeeDetails
    var body: some View {
        HStack(alignment: .top) {
            EmployeeImageUrlView(urlString: employees.photo_url_small)
            VStack(alignment: .leading) {
                Text("\(employees.full_name ?? "")")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("\(employees.phone_number ?? "")").font(.subheadline)
                Text("\(employees.team ?? "")").font(.subheadline)
                Text("\(employees.email_address ?? "")").foregroundColor(.blue)
                Text("\(employees.biography ?? "")").font(.subheadline).fontWeight(.thin).foregroundColor(.secondary)
            }
        }
    }
}

struct EmployeeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeDetailView()
    }
}

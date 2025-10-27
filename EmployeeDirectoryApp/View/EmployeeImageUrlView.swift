//
//  EmployeeImageView.swift
//  EmployeeDirectoryApp
//
//  Created by Twinkle on 2022-04-05.
//

import SwiftUI

struct EmployeeImageView: View {
    @StateObject private var viewModel: EmployeeImageViewModel
    
    init(urlString: String?) {
        _viewModel = StateObject(wrappedValue: EmployeeImageViewModel(urlString: urlString))
    }
    
    var body: some View {
        Group {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if viewModel.isLoading {
                Image(uiImage: EmployeeImageView.defaultImage!)
                    .resizable()
                    .scaledToFit()
                    .opacity(0.5)
            } else {
                Image(uiImage: EmployeeImageView.defaultImage!)
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(width: 120, height: 120)
        .clipShape(Circle())
        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
        .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
    }
    
    static let defaultImage = UIImage(named: "load")
}

struct EmployeeImageView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeImageView(urlString: nil)
    }
}

//
//  EmployeeImageUrlView.swift
//  EmployeeDirectoryApp
//
//
//  Created by Twinkle on 2022-04-05.
//

import SwiftUI

struct EmployeeImageUrlView: View {
    @ObservedObject var urlImageModel: EmployeeImageModel
    
    init(urlString: String?) {
        urlImageModel = EmployeeImageModel(urlString: urlString)
    }
    
    var body: some View {
        Image(uiImage: urlImageModel.image ?? EmployeeImageUrlView.defaultImage!)
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120).cornerRadius(8).shadow(color: .gray, radius: 5, x: 1, y: 1)
    }
    
    static var defaultImage = UIImage(named: "load")
}

struct UrlImageView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeImageUrlView(urlString: nil)
    }
}

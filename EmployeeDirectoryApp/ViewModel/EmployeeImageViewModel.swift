//
//  EmployeeImageViewModel.swift
//  EmployeeDirectoryApp
//
//  Created by Twinkle on 2022-04-05.
//

import Foundation
import SwiftUI

class EmployeeImageViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    private var urlString: String?
    private let imageCache = ImageCache.getImageCache()
    
    init(urlString: String?) {
        self.urlString = urlString
        loadImage()
    }
    
    func loadImage() {
        guard let urlString = urlString else {
            return
        }
        
        // Check cache first
        if let cachedImage = imageCache.get(forKey: urlString) {
            image = cachedImage
            return
        }
        
        // Load from URL
        isLoading = true
        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No image data received")
                    return
                }
                
                guard let loadedImage = UIImage(data: data) else {
                    print("Failed to create image from data")
                    return
                }
                
                self?.imageCache.set(forKey: urlString, image: loadedImage)
                self?.image = loadedImage
            }
        }
        
        task.resume()
    }
}


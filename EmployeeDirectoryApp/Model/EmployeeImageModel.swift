//
//  EmployeeImageModel.swift
//  EmployeeDirectoryApp
//
//  Created by Twinkle on 2022-04-05.
//

import Foundation
import UIKit

// MARK: - Image Cache
class ImageCache {
    private var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
    
    // Singleton instance
    private static var shared: ImageCache = {
        let cache = ImageCache()
        return cache
    }()
    
    static func getImageCache() -> ImageCache {
        return shared
    }
}

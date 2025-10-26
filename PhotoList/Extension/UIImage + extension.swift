//
//  UIImage + extension.swift
//  PhotoList
//
//  Created by Pham Khanh Huy on 22/10/25.
//

import UIKit
import Combine
private var imageLoadTaskKey: UInt8 = 0

extension UIImageView {
    
    private var currentTask: URLSessionDataTask? {
       get { objc_getAssociatedObject(self, &imageLoadTaskKey) as? URLSessionDataTask }
       set { objc_setAssociatedObject(self, &imageLoadTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    static var cancellables = NSMapTable<UIImageView, AnyCancellable>(keyOptions: .weakMemory, valueOptions: .strongMemory)
    
    func load(url: URL) {
        let cacheKey = url.absoluteString
        // Check if the image is already in the cache
        if let cachedImage = ImageCache.shared.getImage(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    ImageCache.shared.setImage(image, forKey: cacheKey)
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }

    func loadImage( from url: URL,placeholder: UIImage? = nil,retryCount: Int = 3) {
          // Cancel previous image loading for this UIImageView
          currentTask?.cancel()
          UIImageView.cancellables.object(forKey: self)?.cancel()
          
          // Set placeholder
          self.image = placeholder
          
          let cacheKey = url.absoluteString
          
          if let cachedImage = ImageCache.shared.getImage(forKey: cacheKey) {
              self.image = cachedImage
              return
          }
          
          // ✅ 2. Combine publisher for image downloading
          let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated)) // Decode off main thread
            .tryMap { data, response -> UIImage in
                guard let image = UIImage(data: data) else {
                  throw URLError(.badServerResponse)
                }
                return image
            }
            .handleEvents(receiveOutput: { image in
                ImageCache.shared.setImage(image, forKey: cacheKey)
            })
            .retry(retryCount) // 👈 Automatically retry if a network error occurs
            .receive(on: DispatchQueue.main)
            .replaceError(with: placeholder ?? UIImage()) // fallback on failure
            .sink { [weak self] image in
                self?.image = image
            }
          
        UIImageView.cancellables.setObject(publisher, forKey: self)

    }

}

class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    private init() {}
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}


func saveImageToDisk(image: UIImage, filename: String) {
    guard let data = image.pngData() else {
        print("Failed to convert image to PNG data.")
        return
    }

    // Get the URL for the Documents directory
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Could not find Documents directory.")
        return
    }

    // Construct the full file URL
    let fileURL = documentsDirectory.appendingPathComponent(filename + ".png")

    do {
        try data.write(to: fileURL)
        print("Image saved successfully to: \(fileURL.lastPathComponent)")
    } catch {
        print("Error saving image: \(error.localizedDescription)")
    }
}

func loadImageFromDisk(filename: String) -> UIImage? {
    // Get the Documents directory URL
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Could not find Documents directory.")
        return nil
    }
    
    // Build the full file path (same name used when saving)
    let fileURL = documentsDirectory.appendingPathComponent(filename + ".png")
    
    // Try to load image
    if let image = UIImage(contentsOfFile: fileURL.path) {
        print("✅ Loaded image from: \(fileURL.lastPathComponent)")
        return image
    } else {
        print("❌ Could not load image. File may not exist.")
        return nil
    }
}



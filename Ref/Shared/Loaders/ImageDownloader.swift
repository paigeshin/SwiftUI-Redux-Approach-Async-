//
//  ImageDownloader.swift
//  DownloadImageSwiftUI
//
//  Created by Mohammad Azam on 9/26/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import Foundation

class ImageDownloader: ObservableObject {

    @Published var downloadedData: Data? = nil
    
    func downloadImage(url: String) {
        

        guard let imageURL = URL(string: url) else {
            fatalError("ImageURL is incorrect")
        }
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL)
            DispatchQueue.main.async {
                self.downloadedData = data
            }
        }
    }
    
}

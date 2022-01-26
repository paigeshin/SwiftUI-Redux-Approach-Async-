//
//  String+Extensions.swift
//  MoviesApp
//
//  Created by Mohammad Azam on 10/8/20.
//

import Foundation

extension String {
    
    func urlEncode() -> String {
        self.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? self 
    }
    
    func toInt() -> Int {
        let ratingDouble = Double(self) ?? 0.0
        return Int(ratingDouble.rounded())
    }
    
}

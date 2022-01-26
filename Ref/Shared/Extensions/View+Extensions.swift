//
//  View+Extensions.swift
//  MoviesApp
//
//  Created by Mohammad Azam on 10/8/20.
//

import Foundation
import SwiftUI

extension View {
    
    func embedInNavigationView() -> some View {
        NavigationView { self }
    }
    
}

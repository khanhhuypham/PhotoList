//
//  BaseURLConnectionManager.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 15/8/25.
//

import Foundation

extension NetworkManager {
    
    var baseURL: URL {
        
        switch self {
        
            default:
                return URL(string: environmentMode.baseUrl)!
        }
        
    }
    
}

//
//  PathConnectionManager.swift
//  aloline-phamkhanhhuy
//
//  Created by Pham Khanh Huy on 16/02/2024.
//

import UIKit

extension NetworkManager{
    private static let version = "v2"

    
    var path: String {
        switch self{
            
            //MARK: authentication
            case .getPhotoList(_,_):
                return String(format: "/%@/list",NetworkManager.version)
       
            
        }
    }
}

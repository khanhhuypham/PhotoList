//
//  TaskConnectionManager.swift
//  aloline-phamkhanhhuy
//
//  Created by Pham Khanh Huy on 16/02/2024.
//

import UIKit



struct APIParam{
    var query:[String:Any]? = nil
    var body:Any? = nil
    
    init(query: [String : Any]? = nil, body: Any? = nil) {
        self.query = query
        self.body = body
    }
}

extension NetworkManager{

    var task:APIParam {
        switch self{
            //MARK: authentication
            case .getPhotoList(let limit, let page):
                return APIParam(query:[
                    "limit":limit,
                    "page":page
                ])
        
        }
    }
}


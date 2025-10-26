//
//  MethodConnectionParameter.swift
//  aloline-phamkhanhhuy
//
//  Created by Pham Khanh Huy on 16/02/2024.
//



extension NetworkManager{
    
    var method: Method {
        switch self{
            //MARK: authentication
            case .getPhotoList(_,_):
                return .GET
            

   
        }
    }
}

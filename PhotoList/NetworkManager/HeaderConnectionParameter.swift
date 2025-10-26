//
//  HeaderConnectionParameter.swift
//  aloline-phamkhanhhuy
//
//  Created by Pham Khanh Huy on 16/02/2024.
//


extension NetworkManager{
    
//    @Injected(\.utils) static var utils
//    
//    private func headerJava(ProjectId:ProjectID = .PROJECT_ID_ORDER, Method:Method = .GET) -> [String : String]{
//        
//        @Injected(\.utils.keyChainUtils) var keyChain
//        
//        var projectId:ProjectID = .PROJECT_ID_ORDER_SMALL
//       
//        if(ProjectId == .PROJECT_ID_ORDER){
//            projectId = PermissionUtils.GPBH_1 ? .PROJECT_ID_ORDER_SMALL : .PROJECT_ID_ORDER
//            
//        }else{
//            projectId = ProjectId
//        }
//        
//        var header:[String:String] = [
//            "Method":String(format: "%d", Method.value),
//            "ProjectId":String(format: "%d", projectId.value)
//        ]
//        
//        if Constants.login, let token = keyChain.getAccessToken(){
//            
//            header["Authorization"] = String(format: "Bearer %@", token)
//         
//        }else{
//             if let config = ManageCacheObject.getConfig(){
//                 header["Authorization"] = String(format: "Basic %@", config.api_key ?? "")
//             }
//        }
//        
//        return header
//    }
//    
//    private func headerNode(ProjectId:ProjectID = .PROJECT_ID_ORDER, Method:Method = .GET) -> [String : String]{
//        @Injected(\.utils.keyChainUtils) var keyChain
//        
//        if let token = keyChain.getAccessToken(), ManageCacheObject.isLogin(){
//            return ["Authorization": String(format: "Bearer %@",token), "ProjectId":String(format: "%d", ProjectId.value), "Method":String(format: "%d", Method.value)]
//        }else{
//            return ["Authorization": String(format: "%@", ManageCacheObject.getConfig()?.api_key ?? ""), "ProjectId":String(format: "%d", ProjectId.value), "Method":String(format: "%d", Method.value)]
//            
//        }
//    }

   
    
    var headers: [String : String]? {
        
        switch self{
            //MARK: authentication
            case .getPhotoList(_,_):
                return [:]
  
 
        }
    }
}

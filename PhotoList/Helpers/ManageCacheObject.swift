//
//  ManageCacheObject.swift
//  PhotoList
//
//  Created by Pham Khanh Huy on 22/10/25.
//


//
//  ManageCacheObject.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//


import UIKit


public class ManageCacheObject {
    // MARK: - setConfig
    static func deleteItem(_ key: String){
        
        UserDefaults.standard.removeObject(forKey: key)
        
    }
    
    // MARK: - Username
    static func setEnvironment(_ environment:EnvironmentMode){
        UserDefaults.standard.set(environment.value, forKey: Constants.KEY_DEFAULT_STORAGE.KEY_ENVIRONMENT_MODE)
    }

    static func getEnvironment() -> EnvironmentMode{
        if let environmentValue = UserDefaults.standard.object(forKey: Constants.KEY_DEFAULT_STORAGE.KEY_ENVIRONMENT_MODE){
        
            return EnvironmentMode(value: environmentValue as? Int ?? ONLINE)
            
        }else{
            
            return EnvironmentMode.online
            
        }
    }
    

}

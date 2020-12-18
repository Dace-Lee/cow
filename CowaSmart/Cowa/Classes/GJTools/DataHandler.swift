//
//  DataHandler.swift
//  Cowa
//
//  Created by gaojun on 2017/8/1.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit

class DataHandler: NSObject {
    
    static let handle = DataHandler()
    
    func createDataTable(_ imei:String){
        
        if imei != ""{

            let dataArray = NSMutableArray()
            UserDefaults.standard.set(dataArray, forKey: imei)
            
        }
        
    }
    
    func removeAllData(_ imei:String){
        
        if let dataTable = UserDefaults.standard.object(forKey: imei) {
  
            
            let dataArray = (dataTable as? NSArray)!
            
            let dataArray2 = NSMutableArray.init(array: dataArray)
            
            dataArray2.removeAllObjects()
            
            UserDefaults.standard.set(dataArray2, forKey: imei)
            
        }
        
    }
    
    
    func addUser(_ user:String, imei:String){
        
        if let dataTable = UserDefaults.standard.object(forKey: imei) {
            
            let dataArray = (dataTable as? NSArray)!
            
            let dataArray2 = NSMutableArray.init(array: dataArray)
            
            if !dataArray2.contains(user){
                
                dataArray2.add(user)
                

                
                UserDefaults.standard.set(dataArray2, forKey: imei)
                
            }
            
        }
        
    }
    
    func deleteUser(_ user:String, imei:String){
        
        if let dataTable = UserDefaults.standard.object(forKey: imei) {
            

            let dataArray = (dataTable as? NSArray)!
            
            let dataArray2 = NSMutableArray.init(array: dataArray)
            
            if dataArray2.contains(user){
                
                dataArray2.remove(user)
                

                
                UserDefaults.standard.set(dataArray2, forKey: imei)
                
            }
            
        }
        
    }
    
    func isExistUser(_ imei:String, user:String) -> Bool{
        
        let dataArray = UserDefaults.standard.object(forKey: imei) as? NSArray
            
        if dataArray!.contains(user){
            return true
        }else{
            return false
        }

    }
    
    func isExistImeiData(_ imei:String) -> Bool{
        
        if UserDefaults.standard.object(forKey: imei) != nil {
            
            return true
            
        }
        
        return false
        
    }

}

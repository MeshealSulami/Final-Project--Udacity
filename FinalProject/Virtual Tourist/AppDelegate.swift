//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Shan'ana Fire on 26/01/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
   
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreData.saveContext()
    }
    
    
}

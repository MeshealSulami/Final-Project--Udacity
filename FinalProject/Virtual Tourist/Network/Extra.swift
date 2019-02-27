//
//  Error.swift
//  Virtual Tourist
//
//  Created by Shan'ana Fire on 09/02/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit



extension UIViewController {
    
    func displayAlert(title:String, message:String?) {
        
        if let message = message {
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

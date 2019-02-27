//
//  Notification.swift
//  Virtual Tourist
//
//  Created by Shan'ana Fire on 09/02/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation



func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

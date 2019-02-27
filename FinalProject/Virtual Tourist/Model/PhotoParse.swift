//
//  PhotoParse.swift
//  Virtual Tourist
//
//  Created by Shan'ana Fire on 08/02/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct PhotosParser: Codable {
    let photos: Photos
}

struct Photos: Codable {
    let pages: Int
    let photo: [PhotoParser]
}

struct PhotoParser: Codable {
    
    let url: String?
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url_n"
        case title
    }
}

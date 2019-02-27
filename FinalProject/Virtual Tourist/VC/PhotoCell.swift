//
//  PhotoCell.swift
//  Virtual Tourist
//
//  Created by Shan'ana Fire on 09/02/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var imageUrl: String = ""

}

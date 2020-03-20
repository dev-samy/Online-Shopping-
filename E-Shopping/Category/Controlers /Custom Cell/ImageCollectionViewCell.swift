//
//  ImageCollectionViewCell.swift
//  E-Shopping
//
//  Created by Abdelrahman Samy on 8.03.2020.
//  Copyright © 2020 Abdelrahman Samy. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setupImageWith(itemImage: UIImage) {
        
        imageView.image = itemImage
    }
    
}

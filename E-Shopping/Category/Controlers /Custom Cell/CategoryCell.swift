//
//  CategoryCell.swift
//  E-Shopping
//
//  Created by Abdelrahman Samy on 6.03.2020.
//  Copyright © 2020 Abdelrahman Samy. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
     func generateCell(_ category: Category) {
           
           nameLabel.text = category.name
           imageView.image = category.image
       }
    
}

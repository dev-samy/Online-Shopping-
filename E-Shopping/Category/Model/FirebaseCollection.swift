//
//  FirebaseCollection.swift
//  E-Shopping
//
//  Created by Abdelrahman Samy on 6.03.2020.
//  Copyright © 2020 Abdelrahman Samy. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollection: String {
    case User
    case Category
    case Items
    case Basket
}

func FirebaseRefrence(_ collectionRefrence: FCollection) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionRefrence.rawValue)
}

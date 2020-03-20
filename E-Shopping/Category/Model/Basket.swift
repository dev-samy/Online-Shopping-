//
//  Basket.swift
//  E-Shopping
//
//  Created by Abdelrahman Samy on 9.03.2020.
//  Copyright © 2020 Abdelrahman Samy. All rights reserved.
//

import Foundation


class Basket {
    
    var id: String!
    var ownerId: String!
    var itemIds: [String]!
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kOBJECTID] as? String
        ownerId = _dictionary[kOWENERID] as? String
        itemIds = _dictionary[kITEMIDS] as? [String]
    }
}


//MARK: - Download items
func downloadBasketFromFirestore(_ ownerId: String, completion: @escaping (_ basket: Basket?)-> Void) {
    
    FirebaseRefrence(.Basket).whereField(kOWENERID, isEqualTo: ownerId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            
            completion(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let basket = Basket(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(basket)
        } else {
            completion(nil)
        }
    }
}


//MARK: - Save to Firebase
func saveBasketToFirestore(_ basket: Basket) {
    
    FirebaseRefrence(.Basket).document(basket.id).setData(basketDictionaryFrom(basket) as! [String: Any])
}




//MARK:- Helper functions

func basketDictionaryFrom(_ basket: Basket) -> NSDictionary {
    
    return NSDictionary(objects: [basket.id, basket.ownerId, basket.itemIds], forKeys: [kOBJECTID as NSCopying, kOWENERID as NSCopying, kITEMIDS as NSCopying])
}

//MARK: - Update basket
func updateBasketInFirestore(_ basket: Basket, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
    
    
    FirebaseRefrence(.Basket).document(basket.id).updateData(withValues) { (error) in
        completion(error)
    }
}





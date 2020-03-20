//
//  HelperCrunncy.swift
//  E-Shopping
//
//  Created by Abdelrahman Samy on 8.03.2020.
//  Copyright © 2020 Abdelrahman Samy. All rights reserved.
//

import Foundation

func convertToCurrency(_ number: Double) -> String {
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale(identifier: "es_CL")
    
    return currencyFormatter.string(from: NSNumber(value: number))!
}

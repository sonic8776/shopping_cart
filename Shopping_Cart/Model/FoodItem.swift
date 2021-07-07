//
//  Food.swift
//  Shopping_Cart
//
//  Created by Judy Tsai on 2021/7/2.
//

import Foundation

class FoodItem: Equatable {
    
    static func == (lhs: FoodItem, rhs: FoodItem) -> Bool {
        return lhs === rhs
    }
    
    var name: String
    var price: Int
    var serving: Int
    var foodID: String
    
    init(name: String, price: Int, serving: Int) {
        self.name = name
        self.price = price
        self.serving = serving
        self.foodID = UUID().uuidString
    }
}

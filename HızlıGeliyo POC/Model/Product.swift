//
//  Product.swift
//  HızlıGeliyo POC
//
//  Created by Muhammed Gül on 9.09.2020.
//  Copyright © 2020 Muhammed Gül. All rights reserved.
//

import UIKit

public struct Product: Decodable {
    var id: Int
    var title: String
    var price: Float
    var description: String
    var category: String
    var image: String
}

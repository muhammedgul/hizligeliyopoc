//
//  ProductCell.swift
//  HızlıGeliyo POC
//
//  Created by Muhammed Gül on 9.09.2020.
//  Copyright © 2020 Muhammed Gül. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    public func setupCell(withProduct product: Product, atIndex index: Int) {
        
        productImageView.image = nil // prevent displaying wrong images while reusing cells.
        productNameLabel.text = product.title
        productPriceLabel.text = String(product.price) + " TL"
        
        setupImageCorners()
        
        DispatchQueue.global().async {
            guard let url = URL(string: product.image) else {
                return
            }
            if let cachedImage = self.imageCache.object(forKey: url.absoluteString as NSString) {
                DispatchQueue.main.async {
                    if self.tag != index { // prevent race condition
                        return
                    }
                    self.productImageView.image = cachedImage
                }
                return
            }
            do {
                let data = try Data(contentsOf: url)
                if let imageData = UIImage(data: data)?.jpegData(compressionQuality: 0.25), let img = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        if self.tag != index { // prevent race condition
                            return
                        }
                        self.productImageView.image = img
                    }
                    self.imageCache.setObject(img, forKey: url.absoluteString as NSString)
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func setupImageCorners() {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: productImageView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        productImageView.layer.mask = maskLayer
    }
    
}

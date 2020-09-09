//
//  ProductListVC.swift
//  HızlıGeliyo POC
//
//  Created by Muhammed Gül on 8.09.2020.
//  Copyright © 2020 Muhammed Gül. All rights reserved.
//

import UIKit

class ProductListVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var loadingStackView: UIStackView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var products: [Product] = [Product]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.loadingStackView.isHidden = true
            }
        }
    }
    
    // Handle Searching Functionality
    private var searchingProducts: [Product] = [Product]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private var isSearching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchView()
        fetchProducts()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func fetchProducts() {
        URLSession.shared.dataTask(with: Constants.productsURL) { data,response,error in
            if let data = data {
                if let resultArray = try? JSONDecoder().decode([Product].self, from: data) {
                    self.products = resultArray
                }
            }
        }.resume()
    }
    
    private func setupSearchView() {
        shadowView.layer.shadowOffset = CGSize(width: 1, height: 3)
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.shadowRadius = 24
        shadowView.layer.shadowColor = UIColor.darkGray.cgColor
        shadowView.layer.cornerRadius = 10
        
        searchView.clipsToBounds = true
        searchView.layer.cornerRadius = 10
        
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .white
        searchBar.delegate = self
    }
}


extension ProductListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return searchingProducts.count
        } else {
            return products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        cell.tag = indexPath.item // to prevent race condition between cells
        if isSearching {
            cell.setupCell(withProduct: searchingProducts[indexPath.item], atIndex: indexPath.item)
        } else {
            cell.setupCell(withProduct: products[indexPath.item], atIndex: indexPath.item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 7, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
}


extension ProductListVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingProducts.removeAll()
        if searchText.count != 0 {
            isSearching = true
            if products.count != 0 {
                for product in products {
                    if product.title.lowercased().contains(searchText.lowercased()) {
                        searchingProducts.append(product)
                    }
                }
            }
        } else {
            isSearching = false
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

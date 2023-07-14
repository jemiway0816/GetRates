//
//  ScrollableMenuBar3ViewController.swift
//  GetRates
//
//  Created by CHUN-CHIEH LU on 2023/7/14.
//

import UIKit

class ScrollableMenuBar3ViewController: UIViewController, UICollectionViewDataSource {

    var MainVC:MainViewController!
    let imageView = UIImageView()
    
    var images = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 500, height: 200), collectionViewLayout: collectionViewLayout)
        collectionView.register(MenuBar3CollectionViewCell.self, forCellWithReuseIdentifier: "\(MenuBar3CollectionViewCell.self)")
        collectionView.dataSource = self // 設置數據源
        
        view.addSubview(collectionView)

               
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MenuBar3CollectionViewCell.self)", for: indexPath) as! MenuBar3CollectionViewCell
        let img = images[indexPath.item]
        cell.imageView.image = img
        return cell
    }

}
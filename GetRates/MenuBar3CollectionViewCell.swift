//
//  MenuBar3CollectionViewCell.swift
//  GetRates
//
//  Created by CHUN-CHIEH LU on 2023/7/14.
//

import UIKit

class MenuBar3CollectionViewCell: UICollectionViewCell {
    
    var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureImageView()
    }

    private func configureImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.translatesAutoresizingMaskIntoConstraints = false
        
//        contentView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.frame = CGRect(x: 0, y: 0, width: 380, height: 220)
        contentView.addSubview(imageView)
        
//        NSLayoutConstraint.activate([
//
//            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])
    }


    
}

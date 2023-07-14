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
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }


    
}

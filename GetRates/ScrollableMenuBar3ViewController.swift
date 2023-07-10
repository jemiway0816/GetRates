//
//  ScrollableMenuBar3ViewController.swift
//  GetRates
//
//  Created by CHUN-CHIEH LU on 2023/7/9.
//

import UIKit

class ScrollableMenuBar3ViewController: UIViewController {

    let scrollView = UIScrollView()
    let stackView = UIStackView()
   
    var MainVC:MainViewController!
    var scrollImages:[UIImage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        view.addSubview(scrollView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0
        scrollView.addSubview(stackView)
        
        scrollImages = images
        
        for (index, item) in scrollImages.enumerated() {
            
            let imageView = UIImageView(image: item)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 5
            imageView.contentMode = .scaleAspectFit
            
            imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
//            imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            stackView.addArrangedSubview(imageView)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(menuItemTapped(_:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
            imageView.tag = index
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    @objc func menuItemTapped(_ recognizer: UITapGestureRecognizer) {
        guard let index = recognizer.view?.tag else { return }
        let selectedItem = index
        print("使用者選擇了 MenuBar 3 的第 \(selectedItem+1) 張圖")
        
        MainVC.messageLabel.text = "使用者選擇了 MenuBar 3 的第 \(selectedItem+1) 張圖"
        
    }

}

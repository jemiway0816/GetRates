//
//  ScrollableMenuBar2ViewController.swift
//  GetRates
//
//  Created by CHUN-CHIEH LU on 2023/7/1.
//

import UIKit

class ScrollableMenuBar2ViewController: UIViewController {

    let scrollView = UIScrollView()
    let stackView = UIStackView()
   
    var MainVC:MainViewController!
    
    // 取得幣別資訊
    var menuItems = MyData.shared.menuItem

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        scrollView.addSubview(stackView)
        
        // 每個幣別產生 Label
        for (index, item) in menuItems.enumerated() {
            let menuItemLabel = UILabel()
            menuItemLabel.clipsToBounds = true
            menuItemLabel.layer.cornerRadius = 5
            menuItemLabel.text = "   " + item + "   "
            menuItemLabel.backgroundColor = UIColor.lightGray
            menuItemLabel.font = UIFont.systemFont(ofSize: 18)
            menuItemLabel.textColor = UIColor.black
            menuItemLabel.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(menuItemLabel)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(menuItemTapped(_:)))
            menuItemLabel.isUserInteractionEnabled = true
            menuItemLabel.addGestureRecognizer(tapGestureRecognizer)
            
            menuItemLabel.tag = index
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
        print("使用者選擇了 MenuBar 2 的 \(menuItems[selectedItem])")
        
        MainVC.messageLabel.text = "使用者選擇了 MenuBar2 的 \(menuItems[selectedItem])"
        
    }

}

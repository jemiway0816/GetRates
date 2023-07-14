//
//  MainViewController.swift
//  GetRates
//
//  Created by CHUN-CHIEH LU on 2023/7/1.
//

import UIKit
import Kanna
import SwiftyJSON

// 使用 MyData 將幣別資訊傳給 MenuBar2
class MyData {
    static let shared = MyData()
    var menuItem:[String] = []
    
    private init() { }
}

struct data_struct {
    var type:String = ""
    var cashBuy:String = ""
    var cashSell:String = ""
    var ticketBuy:String = ""
    var ticketSell:String = ""
}

var images = [UIImage]()
var getRates = data_struct()
var rates = [data_struct]()

var menuItem:[String] = []


class MainViewController: UIViewController {
      
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var ratesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrapeTaianBank()
        
        for i in 1...9 {
            getimage(i: i)
        }
        
    }
   
    // 將 MenuBar1 和 MenuBar2 加入 MainViewController
    func setupMenuBar() {
        
        // menuBar1
        let scrollableMenuBarViewController = ScrollableMenuBarViewController()
        scrollableMenuBarViewController.MainVC = self
        addChild(scrollableMenuBarViewController)
        view.addSubview(scrollableMenuBarViewController.view)
        scrollableMenuBarViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollableMenuBarViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollableMenuBarViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollableMenuBarViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollableMenuBarViewController.view.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        // menuBar2
        let scrollableMenuBar2ViewController = ScrollableMenuBar2ViewController()
        scrollableMenuBar2ViewController.MainVC = self
        addChild(scrollableMenuBar2ViewController)
        view.addSubview(scrollableMenuBar2ViewController.view)
        scrollableMenuBar2ViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollableMenuBar2ViewController.view.topAnchor.constraint(equalTo: scrollableMenuBarViewController.view.bottomAnchor, constant: 10.0),
            scrollableMenuBar2ViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollableMenuBar2ViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollableMenuBar2ViewController.view.heightAnchor.constraint(equalToConstant: 36)
        ])
        
    }
    
    // 爬蟲台灣銀行網站
    func scrapeTaianBank() -> Void {
        
        let url = URL(string: "https://rate.bot.com.tw/xrt?Lang=zh-TW")!
        
        URLSession.shared.dataTask(with: url) { data, response, error
            in
            if let data {
                let html = String(data: data, encoding: .utf8)!
                DispatchQueue.main.async {

                    self.parseTaiwanBankHTMLAll(html: html)
                    
                    // MenuBar2的資料來源是台灣銀行的幣別，所以要爬完所有匯率資訊才能設定MenuBar
                    self.setupMenuBar()
                }
            }
        }.resume()
    }
    
    // 從台灣銀行取得所有匯率資訊
    func parseTaiwanBankHTMLAll(html:String) {
        
        var gg:String = ""
        
        if let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            
            for i in 1...19 {
                for j in 1...5 {
                    for rate in doc.xpath("//*[@id=\"ie11andabove\"]/div/table/tbody/tr[\(i)]/td[\(j)]") {
                        
                        if j==1 {
                            
                            // 整理資料，取出中文幣別
                            gg = rate.text! as String
                            gg = gg.replacingOccurrences(of: " ", with: "")
                            gg = gg.replacingOccurrences(of: "\r\n", with: "")
                            
                            var endPosition = 0
                            for cc in gg {
                                if cc == "(" {
                                    break
                                }
                                endPosition += 1
                            }
                            
                            let offsetIndex:String.Index = gg.index(gg.startIndex, offsetBy: endPosition)
                            let offsetRange = gg.startIndex ..< offsetIndex
                            
                            getRates.type = String(gg[offsetRange])
                            
                            // 紀錄幣別資訊在 MyData
                            menuItem.append(getRates.type)
                            MyData.shared.menuItem.append(getRates.type)
                        }
                        
                        if j==2 {
                            getRates.cashBuy = rate.text! as String
                        }
                        if j==3 {
                            getRates.cashSell = rate.text! as String
                        }
                        if j==4 {
                            gg = rate.text! as String
                            gg = gg.replacingOccurrences(of: " ", with: "")
                            getRates.ticketBuy = gg.replacingOccurrences(of: "\r\n", with: "")
                        }
                        if j==5 {
                            gg = rate.text! as String
                            gg = gg.replacingOccurrences(of: " ", with: "")
                            getRates.ticketSell = gg.replacingOccurrences(of: "\r\n", with: "")
                        }
                    }
                }
                rates.append(getRates)
            }
        }
//        ratesTableView.reloadData()
    }
    
    func getimage(i:Int) {
        
//        print("urlStr = \(urlStr)")
        let urlStr = "https://www.ghibli.jp/gallery/kazetachinu00\(i).jpg"
        
        if let url = URL(string: urlStr) {
            
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request)
            {
                data, response, error in
                if let data,
                   let image = UIImage(data: data)
                {
                    DispatchQueue.main.async
                    {
                        print("image append \(images.count)")
                        images.append(image)
                        
                        if images.count > 8 {
                            self.setupMenuBar3()
                        }
                    }
                } else {
                    print("data error")
                }
            }.resume()
        } else {
            print("url error")
        }
    }
    
    func setupMenuBar3() {
        
        // menuBar3
        let scrollableMenuBar3ViewController = ScrollableMenuBar3ViewController()
        scrollableMenuBar3ViewController.MainVC = self
        addChild(scrollableMenuBar3ViewController)
        view.addSubview(scrollableMenuBar3ViewController.view)
        scrollableMenuBar3ViewController.images = images
        scrollableMenuBar3ViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollableMenuBar3ViewController.view.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10.0),
            scrollableMenuBar3ViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollableMenuBar3ViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollableMenuBar3ViewController.view.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
}

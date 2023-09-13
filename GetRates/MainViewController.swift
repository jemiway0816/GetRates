//
//  MainViewController.swift
//  GetRates
//
//  Created by CHUN-CHIEH LU on 2023/7/1.
//

import UIKit
import Kanna
import SwiftyJSON

struct data_struct {
    var type:String = ""
    var cashBuy:String = ""
    var cashSell:String = ""
    var ticketBuy:String = ""
    var ticketSell:String = ""
}

// 使用 MyData 將幣別資訊傳給 MenuBar2
class MyData {
    static let shared = MyData()
    var menuItem:[String] = []
    
    private init() { }
}

var getRates = data_struct()
var rates = [data_struct]()

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
      
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var ratesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ratesTableView.delegate = self
        ratesTableView.dataSource = self
        
        
        // 爬蟲台灣銀行網站
        scrapeTaianBank()
        
        // 爬蟲泰國銀行網站
        parseThailandBankHTML()
    }
    
    // tableView 設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return MyData.shared.menuItem.count
        return rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ratesTableView.dequeueReusableCell(withIdentifier: "\(rateTableViewCell.self)", for: indexPath) as! rateTableViewCell
        let rate = rates[indexPath.row]
        
        cell.typeLabel.text = rate.type
        cell.buyLabel.text = rate.cashBuy
        cell.sellLabel.text = rate.cashSell
        cell.ticketBuyLabel.text = rate.ticketBuy
        cell.ticketSellLabel.text = rate.ticketSell
        
        return cell
        
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
//                    self.parseTaiwanBankHTML(html: html)
                    self.parseTaiwanBankHTMLAll(html: html)
                    
                    // MenuBar2的資料來源是台灣銀行的幣別，所以要爬完所有匯率資訊才能設定MenuBar
                    self.setupMenuBar()
                }
            }
        }.resume()
    }
    
    // 從台灣銀行取得台幣對美金現金買賣匯率
    func parseTaiwanBankHTML(html: String) {
        
        if let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            
            for rate in doc.xpath("//*[@id=\"ie11andabove\"]/div/table/tbody/tr[1]/td[2]") {
                print ("台灣銀行 美金現金買入", rate.text!)
//                buyRate.text = "台灣銀行 美金現金買入:\(rate.text!)    "
            }
            for rate in doc.xpath("//*[@id=\"ie11andabove\"]/div/table/tbody/tr[1]/td[3]") {
                print ("台灣銀行 美金現金賣出", rate.text!)
//                sellRate.text = "台灣銀行 美金現金賣出:\(rate.text!)    "
            }
        }
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
        ratesTableView.reloadData()
    }
    
    // 從泰國銀行網站爬蟲匯率資料
    func parseThailandBankHTML() {
        
        let headers = [
            "accept": "application/json, text/plain, */*",
            "accept-encoding": "gzip, deflate, br",
            "accept-language": "zh-TW,zh;q=0.8,en-US;q=0.6,en;q=0.4",
            "authorization": "Basic c3VwZXJyaWNoVGg6aFRoY2lycmVwdXM=",
            "connection": "keep-alive",
            "content-type": "application/json",
            "host": "www.superrichthailand.com",
            "referer": "https://www.superrichthailand.com/",
            "x-access-token": "null",
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.superrichthailand.com/web/api/v1/rates")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                
                print(error!)
                
            } else {
                
                do {
                    
                    let json = try JSON(data: data!)
                    let buyingUSDHead = json["data"]["exchangeRate"][0]["rate"][0]["cBuying"].floatValue
                    let buyingTWDHead = json["data"]["exchangeRate"][13]["rate"][0]["cBuying"].floatValue
                    
                    print ("泰國銀行 泰幣對美金買入\(buyingUSDHead)")
                    print ("泰國銀行 泰幣對台幣買入\(buyingTWDHead)")
                                       
                } catch  {
                    
                }
            }
        })
        dataTask.resume()
    }

}

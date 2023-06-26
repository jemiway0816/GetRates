//
//  ViewController.swift
//  GetRates
//
//  Created by CHUN-CHIEH LU on 2023/6/26.
//

import UIKit
import Kanna
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var buyRate: UILabel!
    @IBOutlet weak var sellRate: UILabel!
    
    @IBOutlet weak var buyRateThailandTW: UILabel!
    @IBOutlet weak var buyRateThailandUS: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrapeTaianBank()
        parseThailandBankHTML()
        
    }
    
    func scrapeTaianBank() -> Void {
        
        let url = URL(string: "https://rate.bot.com.tw/xrt?Lang=zh-TW")!
        
        URLSession.shared.dataTask(with: url) { data, response, error
            in
            if let data {
                let html = String(data: data, encoding: .utf8)!
                DispatchQueue.main.async {
                    self.parseTaiwanBankHTML(html: html)
                }
            }
        }.resume()
    }
    
    func parseTaiwanBankHTML(html: String) {
        
        if let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            
            for rate in doc.xpath("//*[@id=\"ie11andabove\"]/div/table/tbody/tr[1]/td[2]") {
                print ("台灣銀行 美金現金買入", rate.text!)
                buyRate.text = "台灣銀行 美金現金買入:\(rate.text!)    "
            }
            for rate in doc.xpath("//*[@id=\"ie11andabove\"]/div/table/tbody/tr[1]/td[3]") {
                print ("台灣銀行 美金現金賣出", rate.text!)
                sellRate.text = "台灣銀行 美金現金賣出:\(rate.text!)    "
            }
        }
    }
    
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
                    
                    DispatchQueue.main.async {
                        self.buyRateThailandUS.text = "泰國銀行 泰幣對美金買入:" + String(buyingUSDHead)
                        self.buyRateThailandTW.text = "泰國銀行 泰幣對台幣買入:" + String(buyingTWDHead)
                    }
                    
                } catch  {
                    
                }
            }
        })
        dataTask.resume()
    }
}


//
//  rateTableViewCell.swift
//  GetRates
//
//  Created by CHUN-CHIEH LU on 2023/7/1.
//

import UIKit

class rateTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var buyLabel: UILabel!
    @IBOutlet weak var sellLabel: UILabel!
    @IBOutlet weak var ticketBuyLabel: UILabel!
    @IBOutlet weak var ticketSellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

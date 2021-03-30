//
//  CustomCell.swift
//  Protrips
//
//  Created by mac on 12/17/20.
//

import UIKit

class CustomCell: UITableViewCell {


    @IBOutlet weak var bubbleContent: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var secondContentLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    @IBOutlet weak var flipContent: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var numberAuthor: UILabel!
    @IBOutlet weak var flipSecondContent: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //bubbleContent.layer.cornerRadius = bubbleContent.frame.size.height / 2
        //bubbleContent.backgroundColor = UIColor.gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //bubbleContent.layer.cornerRadius = bubbleContent.frame.size.height / 2
        //bubbleContent.backgroundColor = UIColor.gray
        // Configure the view for the selected state
    }

}

//
//  QuizCell.swift
//  DemoApp
//  Created by Pramit on 18/11/19.
//

import UIKit

class QuizCell: UITableViewCell {
    
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblQuestion: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewBG.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

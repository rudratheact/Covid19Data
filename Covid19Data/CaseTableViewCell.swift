//
//  CaseTableViewCell.swift
//  Covid19Stats
//
//  Created by Rudra Evolut on 23/02/22.
//

import UIKit

class CaseTableViewCell: UITableViewCell {
    @IBOutlet weak var stack1Label: UILabel!
    @IBOutlet weak var stack1Data: UIButton!
    @IBOutlet weak var stack2Label: UILabel!
    @IBOutlet weak var stack2Data: UIButton!
    @IBOutlet weak var stack3Label: UILabel!
    @IBOutlet weak var stack3Data: UIButton!
    @IBOutlet weak var stack4Label: UILabel!
    @IBOutlet weak var stack4Data: UIButton!
    @IBOutlet weak var stack5LinkButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var stack5View: UIStackView!
    
    var favButtonCallback: (() -> Void)?
    var linkButtonCallback: (() -> Void)?
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        favButtonCallback?()
    }
    @IBAction func linkButtonTapped(_ sender: UIButton) {
        linkButtonCallback?()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

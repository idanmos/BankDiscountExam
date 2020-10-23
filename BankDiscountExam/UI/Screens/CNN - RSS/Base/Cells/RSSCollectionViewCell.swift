//
//  RSSCollectionViewCell.swift
//  BankDiscountExam
//
//  Created by Idan Moshe on 22/10/2020.
//

import UIKit
import MagazineLayout

class RSSCollectionViewCell: MagazineLayoutCollectionViewCell {
    
    // MARK: - Variables
    
    static let identifier: String = "RSSCollectionViewCell"
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }

}

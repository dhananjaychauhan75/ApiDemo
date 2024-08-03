//
//  DataCell.swift
//  CMExpertise Precticle
//
//  Created by Dhananjay chauhan on 31/03/24.
//

import UIKit

class DataCell: UICollectionViewCell {
    
    //MARK: - Outlet
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var imgWether: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    
    var removeSeletionClosure:(()->Void)?
    
    //MARK: - lifecycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
        // Initialization code
    }
}



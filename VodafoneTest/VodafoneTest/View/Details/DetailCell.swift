//
//  DetailCell.swift
//  VodafoneTest
//
//  Created by Mészáros Kristóf on 2023. 01. 15..
//

import UIKit

class DetailCell: UITableViewCell {
    public static let reuseIdentifier = "DetailCell"
    
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    public func configureWith(_ details: Detail) {
        headlineLabel.text = details.name
        headlineLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        subtitleLabel.text = details.shortDescription
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        bodyLabel.text = details.description
        bodyLabel.font = UIFont.systemFont(ofSize: 12)
    }
}

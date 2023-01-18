//
//  OffersCell.swift
//  VodafoneTest
//
//  Created by Mészáros Kristóf on 2023. 01. 10..
//

import UIKit

class OfferCell: UITableViewCell {
    public static let reuseIdentifier = "OfferCell"
   
    @IBOutlet weak var offerTitle: UILabel!
    @IBOutlet weak var offerDescription: UILabel!
    @IBOutlet weak var redArrowImage: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    public func configureWith(_ offer: Offer) {
        offerTitle.text = offer.name
        offerTitle.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        offerDescription.text = offer.shortDescription
        offerDescription.font = UIFont.systemFont(ofSize: 12)
        redArrowImage.image = UIImage(named: "redArrow")
        
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = false
        cardView.backgroundColor = UIColor(named: "cellCardBackground")
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowOpacity = 0.25
        
        contentView.backgroundColor = UIColor(named: "cellBackground")
    }
}

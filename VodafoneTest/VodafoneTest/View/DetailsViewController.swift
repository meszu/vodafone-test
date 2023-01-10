//
//  DetailsViewController.swift
//  VodafoneTest
//
//  Created by Mészáros Kristóf on 2023. 01. 10..
//

import UIKit

class DetailsViewController: UIViewController {
    
    private var offerDetail: Detail?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let offerDetail = offerDetail else { fatalError("Please pass in a valid Detail object") }
        title = offerDetail.name
        layoutDetails(theoffer: offerDetail)
    }
    
    func layoutDetails(theoffer: Detail) {
        
        titleLabel.text = theoffer.name
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        subtitleLabel.text = theoffer.shortDescription
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        
        bodyLabel.text = theoffer.description
        bodyLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
    }
}

extension DetailsViewController {
    static func instantiate(offerDetail: Detail) -> DetailsViewController {
      guard let vc = UIStoryboard(name: "Main", bundle: nil)
        .instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { fatalError("Unexpectedly failed getting DetailViewController from Storyboard") }

      vc.offerDetail = offerDetail

      return vc
    }
}

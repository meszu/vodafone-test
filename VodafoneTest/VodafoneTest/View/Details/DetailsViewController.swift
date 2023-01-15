//
//  DetailsViewController.swift
//  VodafoneTest
//
//  Created by Mészáros Kristóf on 2023. 01. 10..
//

import UIKit

class DetailsViewController: UIViewController {
    
    var offerDetail: Detail = Detail(id: "0", name: "Sample", shortDescription: "Sample", description: "Sample")
    var receivedOffer: Offer?
    
    @IBOutlet weak var tblDetails: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblDetails.delegate = self
        tblDetails.dataSource = self
        
        tblDetails.rowHeight = UITableView.automaticDimension
        tblDetails.estimatedRowHeight = 200
        
        title = offerDetail.name
    }
}

extension DetailsViewController {
    static func instantiate(offerDetail: Detail, receivedOffer: Offer) -> DetailsViewController {
      guard let vc = UIStoryboard(name: "Main", bundle: nil)
        .instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { fatalError("Unexpectedly failed getting DetailViewController from Storyboard") }

        vc.offerDetail = offerDetail
        vc.receivedOffer = receivedOffer

      return vc
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.reuseIdentifier, for: indexPath) as! DetailCell
    
        cell.configureWith(offerDetail)

        return cell
    }
    
    
}

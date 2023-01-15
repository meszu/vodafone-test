//
//  DetailsViewController.swift
//  VodafoneTest
//
//  Created by Mészáros Kristóf on 2023. 01. 10..
//

import UIKit

class DetailsViewController: UIViewController {
    
    private var offerDetail: Detail?
    private var receivedOffer: Offer?
    
    @IBOutlet weak var tblDetails: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblDetails.delegate = self
        tblDetails.dataSource = self
        
        tblDetails.rowHeight = UITableView.automaticDimension
        tblDetails.estimatedRowHeight = 200
        
        guard let offerDetail = offerDetail else { fatalError("Please pass in a valid Detail object") }
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
        return DetailCell()
    }
    
    
}

//
//  DetailsViewController.swift
//  VodafoneTest
//
//  Created by Mészáros Kristóf on 2023. 01. 10..
//

import Moya
import UIKit

class DetailsViewController: UIViewController {
    
    private let provider = MoyaProvider<DetailsService>()
    var refreshControll = UIRefreshControl()
    
    var offerDetail: Detail = Detail(id: "0", name: "Sample", shortDescription: "Sample", description: "Sample")
    var receivedOffer: Offer?
    
    @IBOutlet weak var tblDetails: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        
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

// MARK: Network and Refresh Control

extension DetailsViewController {
    private func fetchData() {
        provider.request(.details) { result in
            switch result {
            case .success(let response):
                do {
//                    print(try response.mapJSON())
                    let details = try response.map(DetailRecord.self).record
                    if details.id == self.receivedOffer?.id {
                        self.offerDetail = Detail(
                            id: details.id,
                            name: details.name,
                            shortDescription: details.shortDescription,
                            description: details.description)
                    } else {
                        self.offerDetail = Detail(id: "", name: "", shortDescription: "", description: "")
                    }
                    self.tblDetails.reloadData()
                } catch {
                    self.presentError(with: "Something went wrong. Try again later.")
                }
            case .failure(let error):
                print("Failed to download the offers list with error: \(error.localizedDescription)")
                self.presentError(with: "Failed to download the offer list.")
            }
        }
    }
    
    func presentError(with message: String) {
      let alert = UIAlertController(title: "Uh oh", message: message,
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

      present(alert, animated: true, completion: nil)
    }
    
    private func setupRefreshControl() {
        refreshControll.tintColor = UIColor(named: "cellBackground")
        refreshControll.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tblDetails.refreshControl = refreshControll
    }
    
    @objc func refreshContent() {
//        setupSkeletons()
        reset()
        fetchData()
        tblDetails.refreshControl?.endRefreshing()
        tblDetails.reloadData()
    }
    
    @objc func reset() {
        self.offerDetail = Detail(id: "", name: "", shortDescription: "", description: "")
    }
}

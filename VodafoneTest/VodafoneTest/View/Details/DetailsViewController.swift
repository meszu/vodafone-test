//
//  DetailsViewController.swift
//  VodafoneTest
//
//  Created by Mészáros Kristóf on 2023. 01. 10..
//

import Moya
import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: UIViewController {
    
    private let bag = DisposeBag()
    private let viewModel = DetailViewModel()
        
    private let provider = MoyaProvider<DetailsService>()
    var refreshControll = UIRefreshControl()
    
    var receivedOffer: Offer?

    var offerDetail: Detail = Detail(id: "0", name: "Sample", shortDescription: "Sample", description: "Sample")
    
    @IBOutlet weak var tblDetails: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = receivedOffer?.name
        setupRefreshControl()

        tblDetails.rx.setDelegate(self).disposed(by: bag)
        
        bindTableView()
        
        tblDetails.rowHeight = UITableView.automaticDimension
        tblDetails.estimatedRowHeight = 200
        
    }
    
    private func bindTableView() {
        
        viewModel.items.bind(to: tblDetails.rx.items(cellIdentifier: "DetailCell", cellType: DetailCell.self)) { (row,item,cell) in
            if item.id == self.receivedOffer?.id {
                cell.configureWith(item)
            } else {
                cell.configureWith(Detail(id: "", name: "", shortDescription: "", description: ""))
            }
        }.disposed(by: bag)
        
        viewModel.fetchData()
    }
}

// MARK: - Instantiate method

extension DetailsViewController {
    static func instantiate(offerDetail: Detail, receivedOffer: Offer) -> DetailsViewController {
      guard let vc = UIStoryboard(name: "Main", bundle: nil)
        .instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { fatalError("Unexpectedly failed getting DetailViewController from Storyboard") }

        vc.offerDetail = offerDetail
        vc.receivedOffer = receivedOffer

      return vc
    }
}

// MARK: - UITableView Delegate

extension DetailsViewController: UITableViewDelegate {}

// MARK: Network and Refresh Control

extension DetailsViewController {
    private func fetchData() {
        provider.request(.details) { result in
            switch result {
            case .success(let response):
                do {
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
}

// MARK: - Pull to Refresh

extension DetailsViewController {
    private func setupRefreshControl() {
        refreshControll.tintColor = UIColor(named: "cellBackground")
        refreshControll.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tblDetails.refreshControl = refreshControll
    }
    
    @objc func refreshContent() {
        viewModel.fetchData()
        tblDetails.refreshControl?.endRefreshing()
    }
    
    @objc func reset() {
        self.offerDetail = Detail(id: "", name: "", shortDescription: "", description: "")
    }
}

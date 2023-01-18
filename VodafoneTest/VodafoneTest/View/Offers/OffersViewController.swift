//
//  ViewController.swift
//  VodafoneTest
//
//  Created by Mészáros Kristóf on 2023. 01. 06..
//

import Moya
import UIKit

class OffersViewController: UIViewController {
    @IBOutlet weak var tblOffers: UITableView!
    
    let provider = MoyaProvider<OffersService>()
    let detailProvider = MoyaProvider<DetailsService>()
    
    var refreshControl = UIRefreshControl()
    
    var detailsToPresent: Detail?

    var sections: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        fetchDetailData()
        setupRefreshControl()
        
        tblOffers.delegate = self
        tblOffers.dataSource = self
        
        tblOffers.rowHeight = UITableView.automaticDimension
        tblOffers.estimatedRowHeight = 140
        tblOffers.backgroundColor = UIColor(named: "cellBackground")
        
        title = "Offers"
                
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "backButtonColor")
    }
}

// MARK: - Pull to Refresh

extension OffersViewController {
    private func setupRefreshControl() {
        refreshControl.tintColor = UIColor(named: "cellBackground")
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tblOffers.refreshControl = refreshControl
    }
    
    @objc func refreshContent() {
        reset()
        tblOffers.reloadData()
        fetchData()
        tblOffers.refreshControl?.endRefreshing()
    }
    
    @objc func reset() {
        sections = []
    }
}

// MARK: - Networking

extension OffersViewController {
    private func fetchData() {
        provider.request(.offers) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    /* Parse the JSON file, exclude offers where "id" or "rank" parameter is nil. */
                    let allOffers = try response.map(Offers.self).record.offers.filter { $0.rank != nil && $0.rank != 0 && $0.id != nil && $0.id != "" }
                    
                    /* Filter all offers based on wheter they are special offers or normal offers. */
                    let specOffs = allOffers.filter { $0.isSpecial }
                    let normOffs = allOffers.filter { !$0.isSpecial }
                    
                    /* If special offers array is not empty, create a Section with a title of "Special Offers", and populate the cells with the
                       special offers array.
                     */
                    if !specOffs.isEmpty {
                        self.sections.append(Section(title: "Special Offers", cells: specOffs))
                    }
                    
                    /* If normal offers array is not empty, create a Section with a title of "Offers", and populate the cells with the
                       special offers array.
                     */
                    if !normOffs.isEmpty {
                        self.sections.append(Section(title: "Offers", cells: normOffs))
                    }
                    
                    self.tblOffers.reloadData()
                } catch {
                    self.presentError(title: "Uh Oh", message: "Something went wrong while parsing the data. Try again later.")
                }
            case .failure:
                self.presentError(title: "Sorry", message: "Failed to download the offer list.")
            }
        }
    }
    
    private func fetchDetailData() {
        detailProvider.request(.details) { [self] result in
            switch result {
            case .success(let response):
                do {
                    let details = try response.map(DetailRecord.self).record
                    
                    detailsToPresent = Detail(
                        id: details.id,
                        name: details.name,
                        shortDescription: details.shortDescription,
                        description: details.description)
                } catch {
                    self.presentError(title: "Decoding Error", message: "Something went wrong. Try again later.")
                }
            case .failure(let error):
                print("Failed to download the offers list with error: \(error.localizedDescription)")
                self.presentError(title: "Download Error", message: "Failed to download the offer list.")
            }
        }
    }
    
    func presentError(title: String, message: String) {
      let alert = UIAlertController(title: title, message: message,
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

      present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableView Delegate & Data Source

extension OffersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OfferCell.reuseIdentifier, for: indexPath) as! OfferCell

        let currentOffer = sections[indexPath.section].cells[indexPath.row]
        
        cell.configureWith(currentOffer)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //    fetchDetailData()
        
        guard let detailsToPresent = detailsToPresent else { return }
        
        let currentOffer = sections[indexPath.section].cells[indexPath.row]
        
        var detailToSend: Detail
        
        if currentOffer.id == detailsToPresent.id {
            detailToSend = Detail(id: detailsToPresent.id, name: detailsToPresent.name, shortDescription: detailsToPresent.shortDescription, description: detailsToPresent.description)
        } else {
            detailToSend = Detail(id: "", name: "", shortDescription: "", description: "")
        }
        
        let detailVC = DetailsViewController.instantiate(offerDetail: detailToSend, receivedOffer: currentOffer)

        navigationController?.show(detailVC, sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderLabelView = UIView()
        sectionHeaderLabelView.backgroundColor = UIColor(named: "cellBackground")
        sectionHeaderLabelView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40)
        
        let sectionHeaderLabel = UILabel()
        sectionHeaderLabel.text = sections[section].title
        sectionHeaderLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        if section == 0 {
            sectionHeaderLabel.frame = CGRect(x: 16, y: 16, width: 250, height: 35)
        } else {
            sectionHeaderLabel.frame = CGRect(x: 16, y: 8, width: 250, height: 35)
        }

        sectionHeaderLabelView.addSubview(sectionHeaderLabel)
        
        return sectionHeaderLabelView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 77
        } else {
            return 61
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

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
    var refreshControl = UIRefreshControl()
    
    var sections: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupRefreshControl()
        
        tblOffers.delegate = self
        tblOffers.dataSource = self
        
        tblOffers.rowHeight = UITableView.automaticDimension
        tblOffers.estimatedRowHeight = 140
        tblOffers.backgroundColor = UIColor(named: "cellBackground")
        
        navigationController?.navigationBar.barTintColor = UIColor.white
                
        title = "Offers"
        
        /* Set the DetailView's back button's title to "Back" */
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Back", style: .plain, target: nil, action: nil)
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
//        setupSkeletons()
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
                    let allOffers = try response.map(Offers.self).record.offers
                    let specOffs = allOffers.filter { $0.isSpecial }
                    let normOffs = allOffers.filter { !$0.isSpecial }
                    
                    if !specOffs.isEmpty {
                        self.sections.append(Section(title: "Special Offers", cells: specOffs))
                    }
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

//        let currentOffer = offers[indexPath.row]
        let currentOffer = sections[indexPath.section].cells[indexPath.row]
        
        cell.configureWith(currentOffer)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailsViewController.instantiate(offerDetail: Detail(id: 1, name: "Bestest 1 GB", shortDescription: "legjobb egy giga amit csak kaphatsz", description: "Remek ár érték arányban kaphatod meg ezt a csúcsszuper egy gigabájtnyi adatot amit arra használsz fel amire csak akarsz"))
        navigationController?.show(detailVC, sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderLabelView = UIView()
        sectionHeaderLabelView.backgroundColor = UIColor(named: "cellBackground")
        sectionHeaderLabelView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 72)
        
        let sectionHeaderLabel = UILabel()
        sectionHeaderLabel.text = sections[section].title
        sectionHeaderLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        sectionHeaderLabel.frame = CGRect(x: 16, y: 0, width: 250, height: 35)
        
        sectionHeaderLabelView.addSubview(sectionHeaderLabel)
        
        sectionHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionHeaderLabel.centerYAnchor.constraint(equalTo: sectionHeaderLabelView.centerYAnchor, constant: -8),
            sectionHeaderLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: sectionHeaderLabelView.leadingAnchor, multiplier: 2)
        ])
        
        return sectionHeaderLabelView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

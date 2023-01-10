//
//  ViewController.swift
//  VodafoneTest
//
//  Created by Mészáros Kristóf on 2023. 01. 06..
//

import UIKit

class OffersViewController: UIViewController {

    @IBOutlet weak var tblOffers: UITableView!
    
    var offers: [Offer] = [
        Offer(id: "1", rank: 1, isSpecial: true, name: "100MB", shortDescription: "rovid 100 MB adat"),
        Offer(id: "2", rank: 2, isSpecial: true, name: "300MB", shortDescription: "gyors 300MB adat very nice"),
        Offer(id: "3", rank: 3, isSpecial: false, name: "400MB", shortDescription: "gyors 400MB internet ami szélsebesen szárnyal az internet mély bugyraiban, kellemesen használható télen nyáron"),
        Offer(id: "4", rank: 4, isSpecial: false, name: "500MB", shortDescription: "verygyors 500MB"),
        Offer(id: "5", rank: 21, isSpecial: true, name: "1GB", shortDescription: "ubergyors internet"),
        Offer(id: "6", rank: 22, isSpecial: false, name: "2GB", shortDescription: "uberultragyorsnet")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "cellBackground")
        
        tblOffers.delegate = self
        tblOffers.dataSource = self
        
        tblOffers.rowHeight = UITableView.automaticDimension
        tblOffers.estimatedRowHeight = 140
        tblOffers.backgroundColor = UIColor(named: "cellBackground")
        
        tblOffers.tableHeaderView = .init(frame: .init(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        
                
        title = "Offers"
        
        /* Set the DetailView's back button's title to "Back" */
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Back", style: .plain, target: nil, action: nil)
    }

    var sections: [Section] = [
        Section(title: "Special Offers",
                cells: Offers.mockData
               ),
        Section(title: "Offers",
                cells: Offers.mockData.reversed()
               )]

}

// MARK: - UITableView Delegate & Data Source

extension OffersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OfferCell.reuseIdentifier, for: indexPath) as! OfferCell

        let currentOffer = offers[indexPath.row]
        
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
        sectionHeaderLabel.frame = CGRect(x: 16, y: 8, width: 250, height: 35)
        
        sectionHeaderLabelView.addSubview(sectionHeaderLabel)
        
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

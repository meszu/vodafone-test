//
//  ViewController.swift
//  VodafoneTest
//
//  Created by Mészáros Kristóf on 2023. 01. 06..
//

import Moya
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class OffersViewController: UIViewController {
    @IBOutlet weak var tblOffers: UITableView!
    
    var viewModel: OffersViewModel!
    private var bag = DisposeBag()
    
    var dataSource: RxTableViewSectionedReloadDataSource<OfferSectionModel>!
    
    var detailsToPresent: Detail?
    
    let detailProvider = MoyaProvider<DetailsService>()
    
    var refreshControl = UIRefreshControl()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModel()
        configureSectionModel()
        configureTableView()
        setupRefreshControl()
        viewModel.delegate = self
        
        tblOffers.rowHeight = UITableView.automaticDimension
        tblOffers.estimatedRowHeight = 140
        tblOffers.backgroundColor = UIColor(named: "cellBackground")
        
        title = "Offers"
                
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "backButtonColor")
    }
    
    private func configureViewModel() {
       viewModel = OffersViewModel()
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
        viewModel.fetchData()
        tblOffers.refreshControl?.endRefreshing()
    }
}

// MARK: - Networking
extension OffersViewController {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<OfferSectionModel> {
        return RxTableViewSectionedReloadDataSource<OfferSectionModel>(
            configureCell: { dataSource, tableView, indexPath, _ in
                switch dataSource[indexPath] {
                case let .offerItem(offer: offer):
                    let cell: OfferCell = tableView.dequeueReusableCell(withIdentifier: OfferCell.reuseIdentifier, for: indexPath) as? OfferCell ?? OfferCell()
                    cell.configureWith(offer)
                    
                    return cell
                }
            })
    }
    
    private func configureSectionModel() {
        viewModel.fetchData()
        
        let dataSource = OffersViewController.dataSource()
        
        viewModel
            .sectionModels
            .drive(tblOffers.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        tblOffers.rx.modelSelected(OfferSectionItem.self)
            .asDriver()
            .drive(onNext: { [weak self] model in
                switch model {
                case .offerItem(offer: let offer):
                    self!.viewModel.fetchDetailData()
                    let detailToSend = self!.viewModel.detailsToPresent
                    let detailVC = DetailsViewController.instantiate(offerDetail: detailToSend, receivedOffer: offer)
                    
                    self?.navigationController?.pushViewController(detailVC, animated: true)
                }
            }).disposed(by: bag)
        
        tblOffers.refreshControl?.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.fetchData()
            })
            .disposed(by: bag)
    }
    
    private func configureTableView() {
        tblOffers
            .rx.setDelegate(self)
            .disposed(by: bag)
    }
    
    private func presentAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: "\(title) Selected", message: "It cost you \(message)", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableView Delegate methods

extension OffersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderLabelView = UIView()
        sectionHeaderLabelView.backgroundColor = UIColor(named: "cellBackground")
        sectionHeaderLabelView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 72)
        
        let sectionHeaderLabel = UILabel()
        sectionHeaderLabel.text = viewModel.sectionHeaders[section]
        sectionHeaderLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        if section == 0 {
            sectionHeaderLabel.frame = CGRect(x: 16, y: 20, width: 250, height: 35)
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
            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: - Error Alert

extension OffersViewController: OffersViewModelDelegate {
    func showError(_ title: String, _ message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

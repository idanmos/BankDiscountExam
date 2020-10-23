//
//  TravelCollectionViewController.swift
//  BankDiscountExam
//
//  Created by Idan Moshe on 22/10/2020.
//

import UIKit
import SVProgressHUD

class TravelCollectionViewController: BaseFeedCollectionViewController {
    
    // MARK: - Variables
    
    private var didRemoveLoader: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        self.tabBarController?.navigationItem.title = "Travel"
        
        self.workerQueue.name = "com.idanmoshe.bankDiscountExam.travelQueue"
        self.workerQueue.maxConcurrentOperationCount = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RSSCollectionViewCell.identifier, for: indexPath) as! RSSCollectionViewCell
        let rssItem: RSSItem = self.feed[indexPath.item]
        cell.titleLabel.text = rssItem.title
        cell.descriptionLabel.text = rssItem.publicationDate
        
        if rssItem.category == .travel {
            cell.contentView.backgroundColor = .systemTeal
        }
        
        return cell
    }
    
    // MARK: - General methods
    
    @objc override func scheduleOperation() {        
        let travelOperation = RSSOperation(category: Application.Category.travel) { [weak self] (category: Application.Category, feed: [RSSItem]) in
            guard let self = self else { return }
            
            // Stop loader view if needed
            if !self.didRemoveLoader {
                self.didRemoveLoader = true
                SVProgressHUD.dismiss()
            }
            
            // Clean the feed
            self.feed.removeAll()
            
            // Rebuild the feed again
            self.feed.append(contentsOf: feed)
            
            // Reload items
            self.collectionView.reloadData()
        }
        
        self.workerQueue.addOperation(travelOperation)
    }
    
}

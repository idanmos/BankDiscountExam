//
//  SportEntertainmentCollectionViewController.swift
//  BankDiscountExam
//
//  Created by Idan Moshe on 22/10/2020.
//

import UIKit
import SVProgressHUD

class SportEntertainmentCollectionViewController: BaseFeedCollectionViewController {
    
    // MARK: - Variables
    
    private let firstSortedCategory: Application.Category = .worldSport
    private var categories: [Application.Category] = []
    private var didRemoveLoader: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        self.tabBarController?.navigationItem.title = "Sport & Entertainment"
        
        self.workerQueue.name = "com.idanmoshe.bankDiscountExam.sportEntertainmentQueue"
        self.workerQueue.maxConcurrentOperationCount = 2
        
        self.categories.append(self.firstSortedCategory)
        self.categories.append(Application.Category.entertainment)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        self.categories.removeAll()
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RSSCollectionViewCell.identifier, for: indexPath) as! RSSCollectionViewCell
        let rssItem: RSSItem = self.feed[indexPath.item]
        cell.titleLabel.text = rssItem.title
        cell.descriptionLabel.text = rssItem.publicationDate
        
        if rssItem.category == .worldSport {
            cell.contentView.backgroundColor = .systemOrange
        } else if rssItem.category == .entertainment {
            cell.contentView.backgroundColor = .systemPink
        }
        
        return cell
    }
    
    // MARK: - General methods
    
    @objc override func scheduleOperation() {
        for category: Application.Category in self.categories {
            let rssFeedOperation = RSSOperation(category: category) { [weak self] (feedCategory: Application.Category, feed: [RSSItem]) in
                guard let self = self else { return }
                
                // Stop loader view if needed
                if !self.didRemoveLoader {
                    self.didRemoveLoader = true
                    SVProgressHUD.dismiss()
                }
                
                self.feed.removeAll { (obj: RSSItem) -> Bool in
                    return obj.category == feedCategory
                }
                
                self.feed.append(contentsOf: feed)
                
                self.refreshData()
            }
            
            self.workerQueue.addOperation(rssFeedOperation)
        }
    }
    
    private func refreshData() {
        // Save the 1st category to show
        let firstSortFiltered = self.feed.filter { (obj: RSSItem) -> Bool in
            return obj.category == self.firstSortedCategory
        }
        
        // Save the rest of the categories
        let restOfTheCategoriesFiltered = self.feed.filter { (obj: RSSItem) -> Bool in
            return obj.category != self.firstSortedCategory
        }
        
        // Clean the feed
        self.feed.removeAll()
        
        // Rebuild the feed again
        self.feed.append(contentsOf: firstSortFiltered)
        self.feed.append(contentsOf: restOfTheCategoriesFiltered)
        
        // Reload items
        self.collectionView.reloadData()
    }

}

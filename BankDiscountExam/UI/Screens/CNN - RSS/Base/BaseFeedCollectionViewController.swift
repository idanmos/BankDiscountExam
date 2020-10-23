//
//  BaseFeedCollectionViewController.swift
//  BankDiscountExam
//
//  Created by Idan Moshe on 22/10/2020.
//

import UIKit
import MagazineLayout
import SafariServices

class BaseFeedCollectionViewController: UICollectionViewController {
    
    // MARK: - Variables
    
    internal lazy var workerQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "com.idanmoshe.bankDiscountExam.travelQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    internal lazy var magazineLayout: MagazineLayout = {
        let layout = MagazineLayout()
        return layout
    }()
    
    internal var timer: Timer?
    
    internal var feed: [RSSItem] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.collectionViewLayout = self.magazineLayout
        
        self.collectionView.register(UINib(nibName: RSSCollectionViewCell.identifier, bundle: nil),
                                     forCellWithReuseIdentifier: RSSCollectionViewCell.identifier)
        
        self.startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let timer = self.timer, !timer.isValid {
            self.startTimer()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let timer = self.timer, timer.isValid {
            timer.invalidate()
        }
    }
    
    deinit {
        self.timer?.invalidate()
        self.feed.removeAll()
        self.workerQueue.cancelAllOperations()
    }

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.feed.count
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rssItem: RSSItem = self.feed[indexPath.item]
        
        if let url = URL(string: rssItem.link) {
            PreferenceManager.shared.selectedRssItem = rssItem
            
            let safariViewController = SFSafariViewController(url:url)
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - General methods
    
    internal func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: Application.rssRefreshInterval,
                                          target: self,
                                          selector: #selector(self.scheduleOperation),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    @objc internal func scheduleOperation() {
        // Need to override
    }

}

// MARK: - UICollectionViewDelegateMagazineLayout

extension BaseFeedCollectionViewController: UICollectionViewDelegateMagazineLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeModeForItemAt indexPath: IndexPath) -> MagazineLayoutItemSizeMode {
        let widthMode = MagazineLayoutItemWidthMode.halfWidth
        let heightMode = MagazineLayoutItemHeightMode.dynamic
        return MagazineLayoutItemSizeMode(widthMode: widthMode, heightMode: heightMode)
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, visibilityModeForFooterInSectionAtIndex index: Int) -> MagazineLayoutFooterVisibilityMode {
        return .visible(heightMode: .dynamic, pinToVisibleBounds: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, visibilityModeForHeaderInSectionAtIndex index: Int) -> MagazineLayoutHeaderVisibilityMode {
        return .visible(heightMode: .dynamic, pinToVisibleBounds: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, visibilityModeForBackgroundInSectionAtIndex index: Int) -> MagazineLayoutBackgroundVisibilityMode {
        return .hidden
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, horizontalSpacingForItemsInSectionAtIndex index: Int) -> CGFloat {
        return  12
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, verticalSpacingForElementsInSectionAtIndex index: Int) -> CGFloat {
        return  12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsForSectionAtIndex index: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 24, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsForItemsInSectionAtIndex index: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
    }
  
}

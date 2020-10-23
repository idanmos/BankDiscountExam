//
//  ViewController.swift
//  BankDiscountExam
//
//  Created by Idan Moshe on 22/10/2020.
//

import UIKit
import SafariServices

class MainViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var dateAndTimeLabel: UILabel!
    @IBOutlet private weak var emptyLabel: UILabel!
    
    // MARK: - Variables
    
    private var timer: Timer?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.emptyLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openBrowser))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.emptyLabel.addGestureRecognizer(tapGesture)
        
        self.showCurrentDateAndTime()
        self.startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Restart timer if needed
        if let timer = self.timer, !timer.isValid {
            self.startTimer()
        }
        
        // Show last selected rss item title
        if let rssItem: RSSItem = PreferenceManager.shared.selectedRssItem {
            self.emptyLabel.text = rssItem.title
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop timer if needed
        if let timer = self.timer, timer.isValid {
            timer.invalidate()
        }
    }
    
    deinit {
        self.timer?.invalidate()
    }
    
    // MARK: - General methods
    
    private func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: Application.dateRefreshInterval,
                                          target: self,
                                          selector: #selector(self.showCurrentDateAndTime),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    @objc func showCurrentDateAndTime() {
        self.dateAndTimeLabel.text = self.dateFormatter.string(from: Date())
    }
    
    @objc func openBrowser() {
        if let rssItem: RSSItem = PreferenceManager.shared.selectedRssItem {
            if let url = URL(string: rssItem.link) {
                let safariViewController = SFSafariViewController(url: url)
                self.present(safariViewController, animated: true, completion: nil)
            }
        }
    }
    
}


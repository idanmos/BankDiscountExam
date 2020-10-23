//
//  Application.swift
//  BankDiscountExam
//
//  Created by Idan Moshe on 22/10/2020.
//

import Foundation

class Application {
    
    static let dateRefreshInterval: TimeInterval = 60.0
    static let rssRefreshInterval: TimeInterval = 5.0
    
    enum Category {
        
        case none
        case travel
        case worldSport
        case entertainment
        
        var url: String {
            switch self {
            case .travel: return "http://rss.cnn.com/rss/edition_travel.rss"
            case .worldSport: return "http://rss.cnn.com/rss/edition_sport.rss"
            case .entertainment: return "http://rss.cnn.com/rss/edition_entertainment.rss"
            default: return ""
            }
        }
        
    }
    
}

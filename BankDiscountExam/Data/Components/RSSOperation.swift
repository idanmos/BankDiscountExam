//
//  RSSOperation.swift
//  BankDiscountExam
//
//  Created by Idan Moshe on 22/10/2020.
//

import UIKit

class RSSOperation: Operation {
    
    private var parserCompletionHandler: ((Application.Category, [RSSItem]) -> Void)?
    
    private var category: Application.Category = .none
    
    init(category: Application.Category, completionHandler: @escaping (Application.Category, [RSSItem]) -> Void) {
        super.init()
        self.category = category
        self.parserCompletionHandler = completionHandler
    }
    
    override func main() {
        super.main()
        
        let rssParser = CnnRssParser(category: self.category)
        rssParser.startParsing()
        
        if let completionHandler = self.parserCompletionHandler {
            DispatchQueue.main.async {
                completionHandler(self.category, rssParser.getFeed())
            }
        }
    }
    
}

//
//  CnnRssParser.swift
//  BankDiscountExam
//
//  Created by Idan Moshe on 22/10/2020.
//

import Foundation

class CnnRssParser: NSObject {
    
    private var parser: XMLParser!
    
    private var elements: [String: Any] = [:]
    private var elementName: String = ""
    // private var images: [String] = []
    
    private var feedData = RSSItem()
    private var feed: [RSSItem] = []
    
    private var category: Application.Category = .none
    
    init(category: Application.Category) {
        super.init()
        self.category = category
        self.parser = XMLParser(contentsOf: URL(string: self.category.url)!)
        self.parser.delegate = self
    }
    
    func startParsing() {
        self.parser.parse()
    }
    
    func getFeed() -> [RSSItem] {
        return self.feed
    }
    
    /* func getImages() -> [String] {
        return self.images
    } */
    
}

extension CnnRssParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.elementName = elementName
        
        if self.elementName == "item" {
            self.feedData = RSSItem()
            self.elements.removeAll()
        } /* else if elementName == "media:content" {
            if let url: String = attributeDict["url"] {
                self.images.append(url)
            }
        } */
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if !self.feedData.title.isEmpty {
                if self.category != .none {
                    self.feedData.category = category
                }
                
                self.feed.append(self.feedData)
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.elementName == "title" {
            self.feedData.title += string
        } else if self.elementName == "link" {
            self.feedData.link += string
        } else if self.elementName == "description" {
            self.feedData.description += string
        } else if self.elementName == "pubDate" {
            self.feedData.publicationDate += string
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        debugPrint(#function, parseError)
    }
    
}

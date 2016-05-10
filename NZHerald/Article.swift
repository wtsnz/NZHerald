//
//  Article.swift
//  NZHerald
//
//  Created by Will Townsend on 27/04/16.
//
//

import Foundation
import SwiftyJSON

public class Article: NSObject, NSCoding {
    
    public static let DatabaseCollection = "articles"
    
    let id: Int
    let headline: String
    let content: String
    let introText: String
    let imageUrl: String
    
    let authors: [String]
    
    let modifiedDate: NSDate
    let startDate: NSDate
    let createdDate: NSDate
    let storyDate: NSDate
    let sortDate: NSDate
    
    override public var description: String {
        return "\(id) - \(headline)\n"
    }
    
    var databaseKey: String {
        return String(self.id)
    }
    
//    init?(dictionary: [String: AnyObject]) {
//        
//        
//        
//        guard let id = dictionary["object_id"] as? Int else {
//            return nil
//        }
//        
//        self.id = id
//        
//        guard let headline = dictionary["headline"] as? String else {
//            return nil
//        }
//        
//        self.headline = headline
//        
//        guard let content = dictionary["content"] as? String else {
//            return nil
//        }
//        
//        self.content = content
//        
//        guard let introText = dictionary["intro_text"] as? String else {
//            return nil
//        }
//        
//        self.introText = introText
//        
//        guard let media = dictionary["media"] as? [String: AnyObject] else {
//            return nil
//        }
//        
//        guard let mediaContent = media["content"] as? [String: AnyObject] else {
//            return nil
//        }
//        
//        guard let imageUrl = mediaContent["url"] as? String else {
//            return nil
//        }
//        
//        // Image url must be prefixed with this url
//        self.imageUrl = "http://media.nzherald.co.nz/" + imageUrl
//        
//        guard let authorsArray = mediaContent["authors"] as? [[String: AnyObject]] else {
//            return nil
//        }
//        
//        let authors = authorsArray.flatMap { (let authorDictionary) -> String? in
//            if let firstName = authorDictionary["first_name"] as? String, let lastName = authorDictionary["last_name"] as? String {
//                return [firstName, lastName].joinWithSeparator(" ")
//            }
//            return nil
//        }
//        
//        self.authors = authors
//        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.timeZone = NSTimeZone(name: "Auckland/Pacific")
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        
//        guard let modifiedDateString = dictionary["modified_date"] as? String,
//            let modifiedDate = dateFormatter.dateFromString(modifiedDateString) else {
//                return nil
//        }
//        
//        self.modifiedDate = modifiedDate
//        
//        guard let startDateString = dictionary["start_date"] as? String,
//            let startDate = dateFormatter.dateFromString(startDateString) else {
//                return nil
//        }
//        
//        self.startDate = startDate
//        
//        //
//        
//        guard let createdDateString = dictionary["created_date"] as? String,
//            let createdDate = dateFormatter.dateFromString(createdDateString) else {
//                return nil
//        }
//        
//        self.createdDate = createdDate
//        
//        ///
//        
//        guard let storyDateString = dictionary["story_date"] as? String,
//            let storyDate = dateFormatter.dateFromString(storyDateString) else {
//                return nil
//        }
//        
//        self.storyDate = storyDate
//        
//        //
//        
//        guard let sortDateString = dictionary["sort_date"] as? String,
//            let sortDate = dateFormatter.dateFromString(sortDateString) else {
//                return nil
//        }
//        
//        self.sortDate = sortDate
//        
//        super.init()
//        //2016-04-26 18:49:33
//        
//    }

    static func fromJSON(json: JSON) -> Article? {
        
        guard let id = json["object_id"].int else {
            return nil
        }
        
        guard let headline = json["headline"].string else {
            return nil
        }
        
        guard let content = json["content"].string else {
            return nil
        }
        
        guard let introText = json["intro_text"].string else {
            return nil
        }
        
        guard let imageUrlRaw = json["media"]["content"]["url"].string else {
            return nil
        }
        
        // Image url must be prefixed with this url
        let imageUrl = "http://media.nzherald.co.nz/" + imageUrlRaw
        
        guard let authorsArray = json["authors"].array else {
            return nil
        }
        
        let authors = authorsArray.flatMap { (let authorJSON) -> String? in
            if let firstName = authorJSON["first_name"].string, let lastName = authorJSON["last_name"].string {
                return [firstName, lastName].joinWithSeparator(" ")
            }
            return nil
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "Auckland/Pacific")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let modifiedDateString = json["modified_date"].string,
            let modifiedDate = dateFormatter.dateFromString(modifiedDateString) else {
                return nil
        }
        
        guard let startDateString = json["start_date"].string,
            let startDate = dateFormatter.dateFromString(startDateString) else {
                return nil
        }
        
        //
        
        guard let createdDateString = json["created_date"].string,
            let createdDate = dateFormatter.dateFromString(createdDateString) else {
                return nil
        }
        
        ///
        
        guard let storyDateString = json["story_date"].string,
            let storyDate = dateFormatter.dateFromString(storyDateString) else {
                return nil
        }
        
        //
        
        guard let sortDateString = json["sort_date"].string,
            let sortDate = dateFormatter.dateFromString(sortDateString) else {
                return nil
        }
        
        //2016-04-26 18:49:33
        return Article(id: id, headline: headline, content: content, introText: introText, imageUrl: imageUrl, authors: authors, modifiedDate: modifiedDate, startDate: startDate, createdDate: createdDate, storyDate: storyDate, sortDate: sortDate)
    }
    
    public init(id: Int, headline: String, content: String, introText: String, imageUrl: String, authors: [String], modifiedDate: NSDate, startDate: NSDate, createdDate: NSDate, storyDate: NSDate, sortDate: NSDate) {
        self.id = id
        self.headline = headline
        self.content = content
        self.introText = introText
        self.imageUrl = imageUrl
        self.authors = authors
        self.modifiedDate = modifiedDate
        self.startDate = startDate
        self.createdDate = createdDate
        self.storyDate = storyDate
        self.sortDate = sortDate
        
        super.init()
    }
    
    required public init(coder decoder: NSCoder) {
        
        self.id = Int(decoder.decodeInt64ForKey("id"))
        self.headline = decoder.decodeObjectForKey("headline") as! String
        self.content = decoder.decodeObjectForKey("content") as! String
        self.introText = decoder.decodeObjectForKey("introText") as! String
        self.imageUrl = decoder.decodeObjectForKey("imageUrl") as! String
        
        self.authors = decoder.decodeObjectForKey("authors") as! [String]
        
        self.modifiedDate = decoder.decodeObjectForKey("modifiedDate") as! NSDate
        self.startDate = decoder.decodeObjectForKey("startDate") as! NSDate
        self.createdDate = decoder.decodeObjectForKey("createdDate") as! NSDate
        self.storyDate = decoder.decodeObjectForKey("storyDate") as! NSDate
        self.sortDate = decoder.decodeObjectForKey("sortDate") as! NSDate
    }
    
    public func encodeWithCoder(coder: NSCoder) {
        coder.encodeInt64(Int64(self.id), forKey: "id")
        coder.encodeObject(self.headline, forKey: "headline")
        coder.encodeObject(self.content, forKey: "content")
        coder.encodeObject(self.introText, forKey: "introText")
        coder.encodeObject(self.imageUrl, forKey: "imageUrl")
        
        coder.encodeObject(self.authors, forKey: "authors")
        
        coder.encodeObject(self.modifiedDate, forKey: "modifiedDate")
        coder.encodeObject(self.startDate, forKey: "startDate")
        coder.encodeObject(self.createdDate, forKey: "createdDate")
        coder.encodeObject(self.storyDate, forKey: "storyDate")
        coder.encodeObject(self.sortDate, forKey: "sortDate")
    }
    
}

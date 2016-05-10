//
//  LatestNewsOperation.swift
//  NZHerald
//
//  Created by Will Townsend on 23/04/16.
//
//

import Foundation
import YapDatabase
import SwiftyJSON

class LatestNewsOperation: NetworkRequestOperation {
    
    let databaseConnection: YapDatabaseConnection
    
    required init(databaseConnection: YapDatabaseConnection, urlRequest: NSMutableURLRequest) {
        self.databaseConnection = databaseConnection
        
        // generate url request
        
        super.init(urlRequest: urlRequest)
    }
    
    override func processData() {
        
        let json = JSON(data: self.incomingData)
        
        guard let response = json["response"].dictionary else {
            print("json parse error")
            return
        }
        
        guard let data = response["data"]?.array else {
            print("json parse error")
            return
        }
        
        let articles = data.flatMap { Article.fromJSON($0) }
        
//        var articles: [Article] = []
//        
//        for dictionary in data {
//            
//            if let article = Article.fromJSON(dictionary) {
//                articles.append(article)
//            }
//        }
        
//        let articles = data.flatMap { Article(dictionary: $0) }
        
        self.databaseConnection.readWriteWithBlock { (let transation) in
            
            for article in articles {
                transation.setObject(article, forKey: article.databaseKey, inCollection: Article.DatabaseCollection)
            }
            
        }
        
        print(articles)
        
    }
    
}

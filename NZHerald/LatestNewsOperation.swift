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
    
    typealias LatestNewsOperationCompletion = (articles: [Article]) -> ()
    
    let processDataCompletionBlock: LatestNewsOperationCompletion
    
    required init(urlRequest: NSMutableURLRequest, completion: LatestNewsOperationCompletion) {
        self.processDataCompletionBlock = completion
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
        
        self.processDataCompletionBlock(articles: articles)
        
    }
    
}

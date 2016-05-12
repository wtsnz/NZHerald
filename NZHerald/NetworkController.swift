//
//  APIClient.swift
//  NZHerald
//
//  Created by Will Townsend on 22/04/16.
//
//

import Foundation
//import CommonCrypto
import CryptoSwift
import YapDatabase

private let scheme = "http://"
private let endpoint = scheme + "appfeed.nzherald.co.nz/api/"

enum NZHeraldAPI {
    
    /// Fetch the latest news
    case LatestNews(count: Int, page: Int)
    
    var scheme: String {
        return "http://"
    }
    
    var endpoint: String {
        return scheme + "appfeed.nzherald.co.nz/api/"
    }
    
    var path: String {
        switch self {
        case .LatestNews:
            return "latest-news/all"
        }
    }
    
    var params: [String: AnyObject] {
        switch self {
        case .LatestNews(let count, let page):
            return [
                "count": String(count),
                // max page is 87
                "page": String(page)
            ]
        }
    }
    
    var urlRequest: NSMutableURLRequest {
        
        let paramsString = urlParamString(self.params)
        
        let url = self.endpoint + self.path + paramsString
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        signRequest(request)
        
        request.setValue("NZHerald/168 (iPhone; iOS 9.3.1; Scale/2.00)", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Required
        request.setValue("iPhone", forHTTPHeaderField: "device")
        // Optional
        //request.setValue("small", forHTTPHeaderField: "device-screen")
        
        return request
    }
    
}

func urlParamString(urlParams: [String: AnyObject]) -> String {
    var string = urlParams.reduce("?") { (paramString, let dict) -> String in
        paramString.stringByAppendingString("\(dict.0)=\(dict.1)&")
    }
    
    string = string.substringToIndex(string.endIndex.predecessor())
    return string
}

func signRequest(request: NSMutableURLRequest) {
    
    let timestamp = String(Int(NSDate().timeIntervalSince1970))
    let clientSecret = "b2958d185062772260c3fa82cc651e126d54b268"
    let signString = request.HTTPMethod + " " + (request.URL?.relativePath)! + "?" + (request.URL?.query)! + timestamp + clientSecret
    let signature = signString.sha1()
    let authorisation = "apn id=apple_iphone, timestamp=\(timestamp), signature=\(signature)"
    
    request.setValue(authorisation, forHTTPHeaderField: "Authorization")
}

class NetworkController {
    
    lazy var queue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
    
    init() {
        self.queue.name = "NetworkController"
    }
    
    
    func performRequest(request: NZHeraldAPI) {
        
    }
    
    func performRequest(request: NZHeraldAPI, completion: (articles: [Article]) -> Void) {
        
        let operation = LatestNewsOperation(urlRequest: request.urlRequest) { articles in
            completion(articles: articles)
        }
        
        operation.completionBlock = {
            print("done")
        }
        
        self.queue.addOperation(operation)
            
    }
    
    func urlRequest(request: NZHeraldAPI) -> NSMutableURLRequest {
        
        let params = request.params
        let paramsString = self.urlParamString(params)
        
        let url = endpoint + request.path + paramsString
        
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        self.signRequest(urlRequest)
        
        urlRequest.setValue("NZHerald/168 (iPhone; iOS 9.3.1; Scale/2.00)", forHTTPHeaderField: "User-Agent")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Required
        urlRequest.setValue("iPhone", forHTTPHeaderField: "device")
        // Optional
        //request.setValue("small", forHTTPHeaderField: "device-screen")
        
        return urlRequest
        
    }
    
    func urlParamString(urlParams: [String: AnyObject]) -> String {
        var string = urlParams.reduce("?") { (paramString, let dict) -> String in
            paramString.stringByAppendingString("\(dict.0)=\(dict.1)&")
        }
        
        string = string.substringToIndex(string.endIndex.predecessor())
        return string
    }
    
    func signRequest(request: NSMutableURLRequest) {
        
        let timestamp = String(Int(NSDate().timeIntervalSince1970))
        let clientSecret = "b2958d185062772260c3fa82cc651e126d54b268"
        let signString = request.HTTPMethod + " " + (request.URL?.relativePath)! + "?" + (request.URL?.query)! + timestamp + clientSecret
        let signature = signString.sha1()
        let authorisation = "apn id=apple_iphone, timestamp=\(timestamp), signature=\(signature)"
        
        request.setValue(authorisation, forHTTPHeaderField: "Authorization")
    }
    
}

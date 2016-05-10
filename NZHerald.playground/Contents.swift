//: Playground - noun: a place where people can play

import UIKit
import CommonCrypto

import XCPlayground

extension String {
    func sha1() -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joinWithSeparator("")
    }
}

var str = "Hello, playground"

let baseUrl = "http://appfeed.nzherald.co.nz/api/"

let clientSecret = "b2958d185062772260c3fa82cc651e126d54b268"


var timestamp = String(Int(NSDate().timeIntervalSince1970))
//timestamp = "1461188299"

let endpoint = "latest-news/all"

let hash = "GET /api/" + "latest-news/all?count=12" + timestamp + clientSecret

let test = hash.sha1()
//http://appfeed.nzherald.co.nz/api/latest-news/all?count=12


let authorisation = "apn id=apple_iphone, timestamp=1461188299, signature=a982b85f8e32a54fecb8773b299040859f068481"

// Count

let urlParams = [
    "count": "12",
//    "page": "1"
]

func urlParamString(urlParams: [String: String]) -> String {
    var string = urlParams.reduce("?") { (paramString, let dict) -> String in
        paramString.stringByAppendingString("\(dict.0)=\(dict.1)&")
    }
    
    string = string.substringToIndex(string.endIndex.predecessor())
    return string
}

func signRequest(request: NSMutableURLRequest) {
    
    var timestamp = String(Int(NSDate().timeIntervalSince1970))
//    timestamp = "1461210726"
    
    let clientSecret = "b2958d185062772260c3fa82cc651e126d54b268"
    
    let signString = request.HTTPMethod + " " + (request.URL?.relativePath)! + "?" + (request.URL?.query)! + timestamp + clientSecret
    
    let signature = signString.sha1()
    
    let authorisation = "apn id=apple_iphone, timestamp=\(timestamp), signature=\(signature)"
    
    request.setValue(authorisation, forHTTPHeaderField: "Authorization")
    
}

print(urlParamString(urlParams))
print(urlParamString([:]))

let paramString = urlParamString(urlParams)

let stringUrl = baseUrl + endpoint + paramString

let url = NSURL(string: stringUrl)!
let request = NSMutableURLRequest(URL: url)

signRequest(request)

request.setValue("NZHerald/168 (iPhone; iOS 9.3.1; Scale/2.00)", forHTTPHeaderField: "User-Agent")
request.setValue("application/json", forHTTPHeaderField: "Accept")

// Required
request.setValue("iPhone", forHTTPHeaderField: "device")
// Optional
//request.setValue("small", forHTTPHeaderField: "device-screen")

let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (let data, let response, let error) in
    print(error)
    print(response)
    
    if let data = data {
        let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
    }
    
    
    XCPlaygroundPage.currentPage.needsIndefiniteExecution = false
    
    
}
task.resume()

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
//request.setValue(<#T##value: String?##String?#>, forHTTPHeaderField: <#T##String#>)


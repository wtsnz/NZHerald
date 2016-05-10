//
//  NetworkRequestOperation.swift
//  NZHerald
//
//  Created by Will Townsend on 22/04/16.
//
//

import Foundation

class Operation : NSOperation {
    
    override var asynchronous: Bool {
        return true
    }
    
    private var _executing = false {
        willSet {
            willChangeValueForKey("isExecuting")
        }
        didSet {
            didChangeValueForKey("isExecuting")
        }
    }
    
    override var executing: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValueForKey("isFinished")
        }
        
        didSet {
            didChangeValueForKey("isFinished")
        }
    }
    
    override var finished: Bool {
        return _finished
    }
    
    override func start() {
        _executing = true
        execute()
    }
    
    func execute() {
        //fatalError("You must override this")
    }
    
    func finish() {
        _executing = false
        _finished = true
    }
}

class NetworkRequestOperation: Operation, NSURLSessionDataDelegate {
    
    let urlRequest: NSMutableURLRequest
    
    lazy var session: NSURLSession = {
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
    }()
    
    internal var task: NSURLSessionTask?
    internal let incomingData = NSMutableData()
    
    var error: NSError? = nil
    
    init(urlRequest: NSMutableURLRequest) {
        self.urlRequest = urlRequest
        super.init()
    }
    
    override func start() {
        super.start()
        
        guard self.cancelled == false else {
            self.task?.cancel()
            self.finish()
            return
        }
        
        self.task = self.session.dataTaskWithRequest(self.urlRequest)
        self.task?.resume()
    }
    
    func processData() {
        print("Processing Data")
    }
    
    // MARK: - NSURLSessionDelegate
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        
        guard self.cancelled == false else {
            task?.cancel()
            self.finish()
            return
        }
        
        completionHandler(.Allow)
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        
        guard self.cancelled == false else {
            task?.cancel()
            self.finish()
            return
        }
        
        self.incomingData.appendData(data)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        
        guard self.cancelled == false else {
            self.task?.cancel()
            self.finish()
            return
        }
        
        if error != nil {
            print("Failed to receive response: \(error)")
            self.error = error
            self.finish()
            return
        }
        
        self.processData()
        self.finish()
    }
}

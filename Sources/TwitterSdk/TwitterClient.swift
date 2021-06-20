//
//  TwitterClient.swift
//  
//
//  Created by Tomasz on 12/06/2021.
//

import Foundation

@available(iOS 14.0, *)
public class TwitterClient {
    
    /// MARK: - Public variables
    
    public init() {
        self.myDelegate = true ? MySession() : nil
        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: myDelegate, delegateQueue: nil)
    }
    
    public let LIBRARY_VERSION = "v0.0.1"
    public var myDelegate: MySession?

    public var session: URLSession?
    
    /// MARK: - Twitter Errors
    
    public enum TwitterError: Error {
        case ConnectionError
        case UnexpectedError
    }
}

/// MARK: - Helper classes

public class MySession: NSObject, URLSessionTaskDelegate {

    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(nil)
    }
}

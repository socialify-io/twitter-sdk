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
        self.delegate = true ? Session() : nil
        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: delegate, delegateQueue: nil)
    }
    
    public let LIBRARY_VERSION = "v0.0.1"
    public var delegate: Session?

    public var session: URLSession?
    
    /// MARK: - Twitter Errors
    
    public enum TwitterError: Error {
        case ConnectionError
        case UnexpectedError
    }
}

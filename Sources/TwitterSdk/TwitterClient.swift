//
//  TwitterClient.swift
//  
//
//  Created by Tomasz on 12/06/2021.
//

import Foundation

@available(iOS 14.0, *)
public class TwitterClient {
    
    public init() {
        self.myDelegate = true ? MySession() : nil
        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: myDelegate, delegateQueue: nil)
    }
    
    public let LIBRARY_VERSION = "v0.0.1"
    public var myDelegate: MySession?

    public var session: URLSession?
    
    /// MARK: - Public functions
    
    /// Logging in
    /// Parameters:
    ///  - email
    ///  - password
    /// Returns
    /// - true or false
    
    public func login(email: String, password: String, completion: @escaping (Result<Bool, TwitterError>) -> Void) {
        // Preparing a request
        let url = URL(string: "https://twitter.com/sessions")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Setting headers
        request.allHTTPHeaderFields = [
            "Sec-Fetch-Site": "same-origin",
            "Sec-Fetch-Mode": "navigate",
            "Sec-Fetch-User": "?1",
            "Sec-Fetch-Dest": "document",
            "connection": "close",
            "Accept-Encoding": "gzip, deflate",
            "Accept-Language": "en-GB,en-US;q=0.9,en;q=0.8",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36",
            "Upgrade-Insecure-Requests": "1",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        // Setting _mb_tk cookie, can type anything
        let cookies = "_mb_tk=\"socialifyiotothemoon\""
        request.setValue(cookies, forHTTPHeaderField: "Cookie")
        
        let payload: [String: Any] = [
            "redirect_after_login": "%2F",
            "remember_me": "1",
            "authenticity_token": "socialifyiotothemoon", // must be the same as _mb_tk cookie
            "wfa": "1",
            "ui_metrics": "",
            "session%5Busername_or_email%5D": email,
            "session%5Bpassword%5D": password,
        ]
        
        // Parsing payload to data
        request.httpBody = Data(payload.map { "\($0.key)=\($0.value)" }.joined(separator: "&").utf8)
        
        // Sending request
        let dataTask = session?.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                // Checking is logged in
                if "\(String(describing: response.value(forHTTPHeaderField: "Set-Cookie")))".contains("auth_token") {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
        }
        dataTask?.resume()
        
    }
    
    public enum TwitterError: Error {
        case ConnectionError
        case UnexpectedError
    }
}


public class MySession: NSObject, URLSessionTaskDelegate {

    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(nil)
    }
}

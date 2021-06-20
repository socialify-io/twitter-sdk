//
//  login.swift
//  
//
//  Created by Tomasz on 20/06/2021.
//

import Foundation

@available(iOS 14.0, *)
extension TwitterClient {
    
    /// MARK: - Logging in functions
    
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
        self.makeRequest(request: request) { result in
            switch result {
            case .success(let result):
                let response = result["response"]
                if let response = response as? HTTPURLResponse {
                    // Checking is logged in
                    if "\(String(describing: response.value(forHTTPHeaderField: "Set-Cookie")))".contains("auth_token") {
                        completion(.success(true))
                    } else {
                        completion(.success(false))
                    }
                }
            
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

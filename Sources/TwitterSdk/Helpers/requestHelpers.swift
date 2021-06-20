//
//  requestHelpers.swift
//  
//
//  Created by Tomasz on 20/06/2021.
//

import Foundation

@available(iOS 14.0, *)
extension TwitterClient {
    
    /// MARK: - Request helpers
    func makeRequest(request: URLRequest, completion: @escaping (Result<[String: Any], TwitterError>) -> Void) {
        var request = request
        request.addValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36", forHTTPHeaderField: "User-Agent")
        session?.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                  if let _ = error {
                    completion(.failure(TwitterError.ConnectionError))
                  }
                
                completion(.failure(TwitterError.ConnectionError))
                return
                }
            
            let returnBody: [String: Any] = [
                "data": data,
                "response": response
            ]
            
            completion(.success(returnBody))
        }.resume()
    }
}

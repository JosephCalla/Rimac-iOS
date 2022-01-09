//
//  Networking.swift
//  Rimac
//
//  Created by Joseph Estanislao Calla Moreyra on 1/9/22.
//

import Foundation
import UIKit

class MyNetworking {
    
    static let shared = MyNetworking()
    
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func downloadImage(url:URL?, completion: @escaping (UIImage?) -> ()) {
        guard let url = url else {
            completion(nil)
            return
        }
        
        let task = session.downloadTask(with: url) { (localUrl: URL?, response: URLResponse?, error: Error?) in
            if let _ = error {
                completion(nil)
                return
            }
            
            guard let _ = response else {
                completion(nil)
                return
            }
            
            guard let localUrl = localUrl else {
                completion(nil)
                return
            }
            
            do {
                let data = try Data(contentsOf: localUrl)
                completion(UIImage(data: data))
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    
}

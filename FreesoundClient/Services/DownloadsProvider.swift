//
//  DownloadsProvider.swift
//  FreesoundClient
//
//  Created by Anton Shcherba on 9/3/20.
//  Copyright © 2020 Anton Shcherba. All rights reserved.
//

import Foundation
import Combine

protocol DownloadsProvider {
    func download(with url: URL,
                          completion: @escaping((Result<Data, APIError>) -> Void))
}

class DownloadsApi: DownloadsProvider {
    
    public func download(with url: URL,
                          completion: @escaping((Result<Data, APIError>) -> Void)) {
        let task = URLSession.shared.downloadTask(with: url) { (url, response, error) in
            guard error == nil else {
                completion(.failure(.serverError))
                return
            }
            
            do {
                guard let url = url else {
                    completion(.failure(.serverError))
                    return
                }
                
                let data = try Data(contentsOf: url)
                completion(.success(data))
            } catch {
                completion(.failure(.internalError))
            }
        }
        
        task.resume()
    }
}



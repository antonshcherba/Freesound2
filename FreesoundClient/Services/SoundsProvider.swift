//
//  SoundsProvider.swift
//  FreesoundClient
//
//  Created by Anton Shcherba on 4/22/20.
//  Copyright © 2020 Anton Shcherba. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

protocol SoundsProvider {
    func soundsList(searchText: String?) -> AnyPublisher<SoundsPage, APIError>
    
    func soundDetails(id: String?) -> AnyPublisher<SoundFull, APIError>
}

class SoundsApi: SoundsProvider, ObservableObject {
    private let baseURL = "https://freesound.org/apiv2"
    
    private enum Endpoint {
        case textSearch(query: String)
        case soundFull(id: String)
        
        var path: String {
            switch self {
            case let .textSearch(query: query):
                return "/search/text/?&query=\(query)&page=3"
            case let .soundFull(id: id):
                return "/sounds/\(id)/"
            }
        }
    }
    
    private enum Method: String {
        case GET
    }
    
    func soundsList(searchText: String? = nil) -> AnyPublisher<SoundsPage, APIError> {
        request(endpoint: .textSearch(query: searchText ?? ""), method: .GET)
    }
    
    func soundDetails(id: String?) -> AnyPublisher<SoundFull, APIError> {
        request(endpoint: .soundFull(id: id ?? ""), method: .GET)
    }
    
    private func request(for endpoint: Endpoint, method: Method) -> URLRequest {
        let path = (baseURL + endpoint.path)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        guard let url = URL(string: path) else {
            preconditionFailure("Bad url")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = ["Content-Type": "application/json",
                                       "Authorization": "Bearer \(authHandler.authToken)"]
        return request
    }
    
    private func request<T: Codable>(endpoint: Endpoint, method: Method) -> AnyPublisher<T,APIError> {
        let urlRequest = request(for: endpoint, method: method)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError { error in
//                print("Sounds error", error)
                return APIError.serverError
                
        }
            .map {
                print(String.init(data: $0.data, encoding: .utf8))
                return $0.data
                
        }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
//                print("Decode error", error)
                return APIError.parsingError
        }
            .eraseToAnyPublisher()
    }
    
    
    public func download(with request: URLRequest,
                          completion: @escaping((Result<Data, APIError>) -> Void)) {
        let task = URLSession.shared.downloadTask(with: request) { (url, response, error) in
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



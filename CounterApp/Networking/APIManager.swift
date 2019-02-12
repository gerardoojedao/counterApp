//
//  APIManager.swift
//  CounterApp
//
//  Created by Gerardo Ojeda on 11-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import Foundation

final public class ApiManager {
    
    private let baseEndpointUrl = URL(string: Constants.Network.baseUrl)!
    private let session = URLSession(configuration: .default)
    
    public func send<T: APIRequest>(_ request: T, completion: @escaping ResultCallback<DataContainer<T.Response>>) {
        let urlRequest = self.urlRequest(for: request)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                do {
                    
                    let apiResponse = try JSONDecoder().decode(APIResponse<T.Response>.self, from: data)
                    
                    if let dataContainer = apiResponse.data {
                        completion(.success(dataContainer))
                    } else {
                        completion(.failure(APIError.decoding))
                    }
                    
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    private func urlRequest<T: APIRequest>(for request: T) -> URLRequest {
        
        guard let baseUrl = URL(string: request.resourceName, relativeTo: baseEndpointUrl) else {
            fatalError("Bad resourceName: \(request.resourceName)")
        }
        
        let endpoint = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)!
        
        var urlRequest = URLRequest(url: endpoint.url!)
        urlRequest.httpMethod = request.method.description
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            fatalError("Wrong parameters")
        }
        
        return urlRequest
    }
}



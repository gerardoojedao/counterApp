//
//  URLRequest+Extension.swift
//  CounterApp
//
//  Created by Gerardo Ojeda on 11-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import Foundation

internal extension URLRequest {
    
    mutating func encoded<T:APIRequest>(encodable: T) -> URLRequest {
        do {
            httpBody = try JSONEncoder().encode(encodable)
            
            let contentTypeHeaderName = "Content-Type"
            if value(forHTTPHeaderField: contentTypeHeaderName) == nil {
                setValue("application/json", forHTTPHeaderField: contentTypeHeaderName)
            }
            
            return self
        } catch {
            fatalError("Wrong parameters: \(error)")
        }
    }
}


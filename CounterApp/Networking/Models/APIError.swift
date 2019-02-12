//
//  APIError.swift
//  CounterApp
//
//  Created by Gerardo Ojeda on 11-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import Foundation

public enum APIError: Error {
    case decoding
    case connection
    
    var localizedDescription: String {
        switch self {
        case .decoding:
            return Constants.MessageError.decoding
        case .connection:
            return Constants.MessageError.connection
        }
    }
}

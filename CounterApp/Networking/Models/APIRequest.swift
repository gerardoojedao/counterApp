//
//  ApiRequest.swift
//  CounterApp
//
//  Created by Gerardo Ojeda on 11-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import Foundation

public protocol APIRequest: Encodable {

    associatedtype Response: Decodable
    
    var resourceName: String { get }
    var method: HTTPMethod { get }
}

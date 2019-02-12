//
//  DeleteCounter.swift
//  CounterApp
//
//  Created by Gerardo Ojeda on 11-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import Foundation

public struct DeleteCounter: APIRequest {
    public typealias Response = [Counter]
    
    // Notice how we create a composed resourceName
    public var resourceName: String {
        return "counter"
    }
    
    public var method: HTTPMethod {
        return .delete
    }
    
    // Parameters
    private let id: String
    
    public init(id: String) {
        self.id = id
    }
}

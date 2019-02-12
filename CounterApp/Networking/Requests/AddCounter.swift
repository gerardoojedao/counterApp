//
//  AddCounter.swift
//  CounterApp
//
//  Created by Gerardo Ojeda on 11-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import Foundation

public struct AddCounter: APIRequest {
    public typealias Response = [Counter]
    
    // Notice how we create a composed resourceName
    public var resourceName: String {
        return "counter"
    }
    
    public var method: HTTPMethod {
        return .post
    }
    
    public var enconder: Encoder {
        return .JSON
    }
    
    // Parameters
    private let title: String
    
    public init(title: String) {
        self.title = title
    }
}

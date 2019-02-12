//
//  GetCounters.swift
//  CounterApp
//
//  Created by Gerardo Ojeda on 11-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import Foundation

public struct GetCounters: APIRequest {
    public typealias Response = [Counter]
    
    // Notice how we create a composed resourceName
    public var resourceName: String {
        return "counters"
    }

    public var method: HTTPMethod {
        return .get
    }
    
    public var enconder: Encoder {
        return .none
    }
}

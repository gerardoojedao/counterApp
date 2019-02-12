//
//  Counter.swift
//  CounterApp
//
//  Created by Gerardo Ojeda on 11-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import Foundation

public struct Counter:Decodable {
    public let id: String
    public let title:String
    public let count: Int
}

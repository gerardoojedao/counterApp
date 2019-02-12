//
//  DataContainer.swift
//  CounterApp
//
//  Created by Gerardo Ojeda on 11-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import Foundation

public struct DataContainer<Results: Decodable>: Decodable {
    
    public let results: Results
}

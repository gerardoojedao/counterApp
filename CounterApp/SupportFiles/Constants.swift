//
//  Constants.swift
//  CounterApp
//
//  Created by Gerardo Ojeda on 11-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import Foundation


struct Constants {
    
    struct Network {
        static let baseUrl = "http://localhost:3000/api/v1/"
    }
    
    struct MessageError {
        static let decoding = "DECODING_ERROR".localized()
        static let connection = "CONNECTION_ERROR".localized()
    }
}

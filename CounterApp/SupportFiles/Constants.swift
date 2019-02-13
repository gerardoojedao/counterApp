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
        static let baseUrl = "http://192.168.100.23:3000/api/v1/"
    }
    
    struct MessageError {
        static let decoding = "DECODING_ERROR".localized()
        static let connection = "CONNECTION_ERROR".localized()
    }
    
    struct BtnTitle {
        static let add      = "ADD".localized()
        static let edit     = "EDIT".localized()
        static let delete   = "DELETE".localized()
    }
    
    struct Alert {
        static let titleAdddCounter     = "ALERT_TITLE_ADD_COUNTER".localized()
        static let messageAdddCounter   = "MESSAGE_TITLE_ADD_COUNTER".localized()
        static let titleBtnCancel       = "ALERT_TITLE_BTN_CANCEL".localized()
        static let titleBtnConfirm      = "ALERT_TITLE_BTN_CONFIRM".localized()
        static let titleError           = "ALERT_TITLE_ERROR".localized()
    }
    
    struct BarButton {
        static let titleEdit    = "EDIT_TITLE_BAR_BUTTON".localized()
        static let titleDone    = "DONE_TITLE_BAR_BUTTON".localized()
        static let titleAdd     = "ADD_TITLE_BAR_BUTTON".localized()
    }
    
    struct EmptyView {
        static let titleMessage     = "TITLE_EMPTY_VIEW".localized()
        static let subtitleMessage  = "SUBTITLE_EMPTY_VIEW".localized()
    }
}

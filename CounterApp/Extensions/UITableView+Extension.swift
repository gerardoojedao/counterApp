//
//  UITableView+Extension.swift
//  CounterApp
//
//  Created by Gerardo on 2/13/19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func setEmptyView(title: String, subtitle: String) {
        
        let emptyView = ListCounterEmptyView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        emptyView.title = title
        emptyView.subtitle = subtitle
        
        self.backgroundView = emptyView
        self.backgroundView?.alpha = 0.0
        self.separatorStyle = .none
        
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundView?.alpha = 1
            
        }, completion: nil)
        
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

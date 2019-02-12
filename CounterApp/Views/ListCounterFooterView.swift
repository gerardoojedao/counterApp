//
//  ListCounterFooterView.swift
//  CounterApp
//
//  Created by Gerardo on 2/12/19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import UIKit

class ListCounterFooterView: UITableViewHeaderFooterView {

    @IBOutlet private weak var titleLabel: UILabel!
    
    var count: Int! {
        didSet {
            titleLabel.text = "Total: " + String(describing: count!)
            
        }
    }
    
    static var cellIdentifier: String {
        return "ListCounterFooterView"
    }
    
    override open var reuseIdentifier: String? {
        return ListCounterFooterView.cellIdentifier
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}

//
//  ListCounterViewCell.swift
//  CounterApp
//
//  Created by Gerardo on 2/12/19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import UIKit

protocol CounterCellProtocol {
    
    func increseCounterFrom(_ cell:ListCounterViewCell)
    func decreaseCounterFrom(_ cell:ListCounterViewCell)
}

class ListCounterViewCell: UITableViewCell {

    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    var delegate: CounterCellProtocol!
    var oldStepperValue = 0.0
    
    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }
    
    var count: Int! {
        didSet {
            oldStepperValue = Double(exactly: count)!
            countLabel.text = String(describing: count!)
            stepper.value = oldStepperValue
            
        }
    }
    
    static var cellIdentifier: String {
        return "ListCounterViewCell"
    }
    
    override open var reuseIdentifier: String? {
        return ListCounterViewCell.cellIdentifier
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func stepValueChanged(_ sender: Any) {
        
        if stepper.value > oldStepperValue {
            self.delegate.increseCounterFrom(self)
        } else if stepper.value < oldStepperValue {
            self.delegate.decreaseCounterFrom(self)
        }
        
        oldStepperValue = self.stepper.value
    }
    
}

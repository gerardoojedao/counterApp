//
//  ViewController.swift
//  CounterApp
//
//  Created by Gerardo Ojeda on 11-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let Manager = ApiManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Manager.send(GetCounters()) { (response) in
            
            switch response {
                
            case .success(let response):
                print(response)
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
        
        /*Manager.send(AddCounter(title: "asd")) { (response) in
            
            switch response {
                
            case .success(let response):
                print(response)
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }*/
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }


}


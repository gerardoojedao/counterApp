//
//  ListCounterRouter.swift
//  CounterApp
//
//  Created Gerardo Ojeda on 12-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class ListCounterRouter {
    
    weak var viewController: ListCounterViewController?
    
    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = ListCounterViewController(nibName: nil, bundle: nil)
        let interactor = ListCounterInteractor()
        let router = ListCounterRouter()
        let presenter = ListCounterPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}

extension ListCounterRouter: ListCounterWireframeProtocol {
    
    func showDialogAddCounter() {
        
        let alert = UIAlertController(title: Constants.Alert.titleAdddCounter, message: Constants.Alert.messageAdddCounter, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: Constants.Alert.titleBtnCancel, style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: Constants.Alert.titleBtnConfirm, style: .default) { (action) in
            if let textfield = alert.textFields?[0], let title = textfield.text, !title.isEmpty {
                
                self.viewController?.presenter?.addCounter(title: title)
            }
        }
        confirmAction.isEnabled = false
        
        alert.addTextField { (textfield) in
            
            NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: textfield, queue: OperationQueue.main, using:
                {_ in
                    let textCount = textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    
                    confirmAction.isEnabled = textIsNotEmpty
            })
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        self.viewController?.present(alert, animated: true, completion: nil)
    }
}

//
//  ListCounterInteractor.swift
//  CounterApp
//
//  Created Gerardo Ojeda on 12-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class ListCounterInteractor {

    weak var presenter: ListCounterPresenterProtocol?
    let apiClient = ApiManager()
}

extension ListCounterInteractor: ListCounterInteractorProtocol {
    
    func fetchAllCounters() {
        
        self.apiClient.send(GetCounters()) { (response) in
            
            switch response {
                
            case .success(let response):
                self.presenter?.countersFetchedSuccess(counters: response)
                break
                
            case .failure(let error):
                self.presenter?.countersFetchedError(error: error)
                break
            }
        }
    }
    
    func addCounter(title: String) {
        
        self.apiClient.send(AddCounter(title: title)) { (response) in
            
            switch response {
                
            case .success(let response):
                self.presenter?.countersFetchedSuccess(counters: response)
                break
                
            case .failure(let error):
                self.presenter?.countersFetchedError(error: error)
                break
            }
        }
    }
    
    func increaseCounter(id: String) {
        
        self.apiClient.send(IncreaseCounter(id: id)) { (response) in
            
            switch response {
                
            case .success(let response):
                self.presenter?.countersFetchedSuccess(counters: response)
                break
                
            case .failure(let error):
                self.presenter?.countersFetchedError(error: error)
                break
            }
        }
    }
    
    func decreaseCounter(id: String) {
        
        self.apiClient.send(DecreaseCounter(id: id)) { (response) in
            
            switch response {
                
            case .success(let response):
                self.presenter?.countersFetchedSuccess(counters: response)
                break
                
            case .failure(let error):
                self.presenter?.countersFetchedError(error: error)
                break
            }
        }
    }
    
    func deleteCounter(id: String) {
        
        self.apiClient.send(DeleteCounter(id: id)) { (response) in
            
            switch response {
                
            case .success(let response):
                self.presenter?.countersFetchedSuccess(counters: response)
                break
                
            case .failure(let error):
                self.presenter?.countersFetchedError(error: error)
                break
            }
        }
    }
    
}
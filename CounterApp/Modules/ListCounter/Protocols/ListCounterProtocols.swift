//
//  ListCounterProtocols.swift
//  CounterApp
//
//  Created Gerardo Ojeda on 12-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

typealias CountersResponse = [Counter]

//MARK: Wireframe -
protocol ListCounterWireframeProtocol: class {
    func showDialogAddCounter()
}
//MARK: Presenter -
protocol ListCounterPresenterProtocol: class {
    
    //INPUT
    func viewDidLoad()
    func fetchAllCounters()
    func addCounter(title:String)
    func increaseCounter(id: String)
    func decreaseCounter(id:String)
    func deleteCounter(id:String)
    
    func showDialogAddCounter()
    
    //OUTPUT
    func countersFetchedSuccess(counters: CountersResponse)
    func countersFetchedError(error: Error)
}

//MARK: Interactor -
protocol ListCounterInteractorProtocol: class {

  var presenter: ListCounterPresenterProtocol?  { get set }
    
    func fetchAllCounters()
    func addCounter(title:String)
    func increaseCounter(id: String)
    func decreaseCounter(id:String)
    func deleteCounter(id:String)
}

//MARK: View -
protocol ListCounterViewProtocol: class {

  var presenter: ListCounterPresenterProtocol?  { get set }
    
    func setupUI()
    func updateUIWith(_ counters: CountersResponse)
    func showError(error: Error)
}

//
//  ListCounterViewController.swift
//  CounterApp
//
//  Created Gerardo Ojeda on 12-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class ListCounterViewController: UIViewController {

	var presenter: ListCounterPresenterProtocol?
    
    var editBarBtn: UIBarButtonItem!
    var addBarBtn: UIBarButtonItem!
    var doneBarBtn: UIBarButtonItem!
    var tableView: UITableView!
    
    var countersArray = [Counter]()
    var isEditMultipleDelete: Bool = false

	override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter?.viewDidLoad()
    }
    
    func setupNavBar() {
        editBarBtn = UIBarButtonItem(title: Constants.BarButton.titleEdit.localized(), style: .plain, target: self, action: #selector(editCountersTapped(_:)))
        addBarBtn = UIBarButtonItem(title: Constants.BarButton.titleAdd.localized(), style: .plain, target: self, action: #selector(addNewCounterTapped(_:)))
        doneBarBtn = UIBarButtonItem(title: Constants.BarButton.titleDone.localized(), style: .done, target: self, action: #selector(doneEditListTapped(_:)))
    }
    
    func setUpTableView() {
        tableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: ListCounterViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: ListCounterViewCell.cellIdentifier)
        tableView.register(UINib(nibName: ListCounterFooterView.cellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: ListCounterFooterView.cellIdentifier)
        self.view.addSubview(self.tableView)
    }
    
    @IBAction func doneEditListTapped(_ sender: UIBarButtonItem) {
        self.tableView.setEditing(false, animated: true)
        self.isEditMultipleDelete = false
        self.updateUIWith(self.countersArray)
    }
    
    @IBAction func editCountersTapped(_ sender: UIBarButtonItem) {
        
        if !countersArray.isEmpty {
            
            let isEditingMode = !self.tableView.isEditing
            
            self.isEditMultipleDelete = true
            self.tableView.setEditing(isEditingMode, animated: true)
            
            self.updateUIWith(self.countersArray)
        }
    }
    
    @IBAction func addNewCounterTapped(_ sender: UIBarButtonItem) {
        
        presenter?.showDialogAddCounter()
    }
    
    func getTotalCounters() -> Int {
        
        let total = countersArray.map({$0.count}).reduce(0, +)
        return total
    }

}

// MARK: - CounterCellProtocol
extension ListCounterViewController: CounterCellProtocol {
    
    func increseCounterFrom(_ cell: ListCounterViewCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let counter = countersArray[(indexPath.row)]
        self.presenter?.increaseCounter(id: counter.id)
    }
    
    func decreaseCounterFrom(_ cell: ListCounterViewCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let counter = countersArray[(indexPath.row)]
        self.presenter?.decreaseCounter(id: counter.id)
    }
}

// MARK: - ListCounterViewProtocol
extension ListCounterViewController: ListCounterViewProtocol {
    
    func setupUI() {
        setupNavBar()
        setUpTableView()
    }
    
    func updateUIWith(_ counters: CountersResponse) {
        
        DispatchQueue.main.async {
    
            self.countersArray = counters
            
            if !self.isEditMultipleDelete || counters.isEmpty {
                self.tableView.setEditing(false, animated: true)
            }
            
            let isTableviewEditing = self.tableView.isEditing
            
            if !counters.isEmpty {
                self.navigationItem.setRightBarButton(isTableviewEditing ? nil : self.addBarBtn, animated: true)
                self.navigationItem.setLeftBarButton(isTableviewEditing ? self.doneBarBtn : self.editBarBtn, animated: true)
            }
            
            if counters.isEmpty {
                self.navigationItem.setRightBarButton(self.addBarBtn, animated: true)
                self.navigationItem.setLeftBarButton(nil, animated: true)
                self.isEditMultipleDelete = false
            }
            
            self.tableView.reloadSections(IndexSet(integer:0), with: .fade)
            
        }
    }
    
    func showError(error: Error) {
        Helpers.sharedInstance.showAlert(title: "Error", message: error.localizedDescription, vc: self)
    }
}

// MARK: - UITableView
extension ListCounterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCounterViewCell.cellIdentifier, for: indexPath) as! ListCounterViewCell
        
        let counter = countersArray[indexPath.row]
        cell.title = counter.title
        cell.count = counter.count
        cell.delegate = self
        
        return cell
    }
    
}

extension ListCounterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: Constants.BtnTitle.delete) { (action,indexPath)  in
            
            let counter = self.countersArray[indexPath.row]
            self.presenter?.deleteCounter(id: counter.id)
        }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        
        if (!tableView.isEditing) {
            self.navigationItem.setRightBarButton(nil, animated: true)
            self.navigationItem.setLeftBarButton(doneBarBtn, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        
        print(countersArray)
        print(self.isEditMultipleDelete)
        
        self.navigationItem.setRightBarButton(self.addBarBtn, animated: true)
        self.navigationItem.setLeftBarButton(countersArray.isEmpty || self.isEditMultipleDelete ? nil : editBarBtn, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if !countersArray.isEmpty {
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ListCounterFooterView.cellIdentifier) as! ListCounterFooterView
            cell.count = self.getTotalCounters()
            return cell
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if !countersArray.isEmpty {
            return 40.0
        }
        
        return 0.0
    }
}

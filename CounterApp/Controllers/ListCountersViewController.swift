//
//  ListCountersViewController.swift
//  CounterApp
//
//  Created by Gerardo Ojeda on 12-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import UIKit

class ListCountersViewController: UIViewController {

    let apiClient = ApiManager()
    
    var editBarBtn: UIBarButtonItem!
    var addBarBtn: UIBarButtonItem!
    var doneBarBtn: UIBarButtonItem!
    var tableView: UITableView!
    
    var countersArray = [Counter]()
    var isEditMultipleDelete: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getAllCountersOnApi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupUI() {
        setupNavBar()
        setUpTableView()
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
        updateUI()
    }

    @IBAction func editCountersTapped(_ sender: UIBarButtonItem) {
        
        if !countersArray.isEmpty {
            
            let isEditingMode = !self.tableView.isEditing
            
            self.isEditMultipleDelete = isEditingMode
            self.tableView.setEditing(isEditingMode, animated: true)
            
            updateUI()
        }
    }
    
    @IBAction func addNewCounterTapped(_ sender: UIBarButtonItem) {
        
        showDialogAddCounter()
    }
    
    func getTotalCounters() -> Int {
        
        let total = countersArray.map({$0.count}).reduce(0, +)
        return total
    }
    
    func showDialogAddCounter() {
        
        let alert = UIAlertController(title: Constants.Alert.titleAdddCounter, message: Constants.Alert.messageAdddCounter, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: Constants.Alert.titleBtnCancel, style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: Constants.Alert.titleBtnConfirm, style: .default) { (action) in
            if let textfield = alert.textFields?[0], let title = textfield.text, !title.isEmpty {
                
                self.addCounterOnApi(title: title)
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
        
        self.present(alert, animated: true, completion: nil)
    }

    func updateUI() {
        
        let isTableviewEditing = self.tableView.isEditing
        
        if !self.countersArray.isEmpty {
            self.navigationItem.setRightBarButton(isTableviewEditing ? nil : self.addBarBtn, animated: true)
            self.navigationItem.setLeftBarButton(isTableviewEditing ? self.doneBarBtn : self.editBarBtn, animated: true)
        }
        
        if self.countersArray.isEmpty {
            self.navigationItem.setRightBarButton(self.addBarBtn, animated: true)
            self.navigationItem.setLeftBarButton(nil, animated: true)
            self.isEditMultipleDelete = false
        }
    }
}

// MARK: - UITableView
extension ListCountersViewController: UITableViewDataSource {
    
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

extension ListCountersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let deleteAction = UITableViewRowAction(style: .default, title: Constants.BtnTitle.delete) { (action,indexPath)  in

            let counter = self.countersArray[indexPath.row]
            self.deleteCounterOnApi(id: counter.id)
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
        
        if (!tableView.isEditing) {
            self.navigationItem.setRightBarButton(addBarBtn, animated: true)
            self.navigationItem.setLeftBarButton(countersArray.isEmpty ? nil : editBarBtn, animated: true)
        }
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

// MARK: - CounterCellProtocol
extension ListCountersViewController: CounterCellProtocol {
    
    func increseCounterFrom(_ cell: ListCounterViewCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let counter = countersArray[(indexPath.row)]
        increaseCounterOnApi(id: counter.id)
    }
    
    func decreaseCounterFrom(_ cell: ListCounterViewCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let counter = countersArray[(indexPath.row)]
        decreaseCounterOnApi(id: counter.id)
    }
}

// MARK: - Request To Server
extension ListCountersViewController {
    
    func getAllCountersOnApi() {
        
        addBarBtn.isEnabled = false
        
        apiClient.send(GetCounters()) { (response) in
            
            DispatchQueue.main.async {
                self.addBarBtn.isEnabled = true
                
                switch response {
                    
                case .success(let response):
                    self.countersArray = response
                    self.tableView.reloadSections(IndexSet(integer:0), with: .fade)
                    self.updateUI()
                    
                    break
                    
                case .failure(let error):
                    Helpers.sharedInstance.showAlert(title: "Ops", message: error.localizedDescription, vc: self)
                    break
                }
            }
        }
    }
    
    func addCounterOnApi(title: String) {
        
        apiClient.send(AddCounter(title: title)) { (response) in
            
            DispatchQueue.main.async {

                switch response {
                    
                case .success(let response):
                    self.countersArray = response
                    self.tableView.reloadSections(IndexSet(integer:0), with: .fade)
                    self.setupUI()
                    
                    break
                    
                case .failure(let error):
                    Helpers.sharedInstance.showAlert(title: "Ops", message: error.localizedDescription, vc: self)
                    break
                }
            }
        }
    }
    
    func increaseCounterOnApi(id: String) {
        
        apiClient.send(IncreaseCounter(id: id)) { (response) in
            
            DispatchQueue.main.async {
                
                switch response {
                    
                case .success(let response):
                    self.countersArray = response
                    self.tableView.reloadSections(IndexSet(integer:0), with: .fade)
                    break
                    
                case .failure(let error):
                    Helpers.sharedInstance.showAlert(title: "Ops", message: error.localizedDescription, vc: self)
                    break
                }
            }
        }
    }
    
    func decreaseCounterOnApi(id: String) {
        
        apiClient.send(DecreaseCounter(id: id)) { (response) in
            
            DispatchQueue.main.async {
                
                switch response {
                    
                case .success(let response):
                    self.countersArray = response
                    self.tableView.reloadSections(IndexSet(integer:0), with: .fade)
                    break
                    
                case .failure(let error):
                    Helpers.sharedInstance.showAlert(title: "Ops", message: error.localizedDescription, vc: self)
                    break
                }
            }
        }
    }
    
    func deleteCounterOnApi(id: String) {
        
        self.apiClient.send(DeleteCounter(id: id)) { (response) in
            
            DispatchQueue.main.async {

                switch response {
                    
                case .success(let response):

                    self.countersArray = response
                    self.tableView.reloadSections(IndexSet(integer:0), with: .fade)
                    
                    if !self.isEditMultipleDelete || response.isEmpty {
                        
                        self.tableView.setEditing(false, animated: true)
                        self.updateUI()
                    }

                    break
                    
                case .failure(let error):
                    Helpers.sharedInstance.showAlert(title: "Ops", message: error.localizedDescription, vc: self)
                    break
                }
            }
        }
    }
}



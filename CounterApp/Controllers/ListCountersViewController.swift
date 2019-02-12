//
//  ListCountersViewController.swift
//  CounterApp
//
//  Created by Gerardo Ojeda on 12-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import UIKit

private enum TableViewMode {
    case edit
    case none
}

class ListCountersViewController: UIViewController {

    let apiClient = ApiManager()
    
    var editBarBtn: UIBarButtonItem!
    var addBarBtn: UIBarButtonItem!
    var tableView: UITableView!
    var totalNumberLabel: UILabel!
    
    var countersArray = [Counter]() {
        didSet {
            totalNumberLabel.text = String(describing: self.getTotalCounters())
            /*self.tableView.beginUpdates()
            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
            self.tableView.endUpdates()*/
        }
    }
    
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
        setUpToolbar()
    }
    
    func setupNavBar() {
        editBarBtn = UIBarButtonItem(title: Constants.BtnTitle.edit.localized(), style: .plain, target: self, action: #selector(editCountersTapped(_:)))
        addBarBtn = UIBarButtonItem(title: Constants.BtnTitle.add.localized(), style: .plain, target: self, action: #selector(addNewCounterTapped(_:)))
        self.navigationItem.leftBarButtonItem = editBarBtn
        self.navigationItem.rightBarButtonItem = addBarBtn
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
    
    func setUpToolbar() {
        totalNumberLabel = UILabel()
        totalNumberLabel.numberOfLines = 0
        totalNumberLabel.textAlignment = .right
        totalNumberLabel.text = String(describing: self.getTotalCounters())
        
        let titleView = UIBarButtonItem(customView: totalNumberLabel)
        
        self.toolbarItems = [titleView]
        self.navigationController?.setToolbarHidden(false, animated: false)
    }

    @IBAction func editCountersTapped(_ sender: UIBarButtonItem) {
        
        if countersArray.count > 0 {
            let isEditing = !self.tableView.isEditing
            self.tableView.setEditing(isEditing, animated: true)
            
            if isEditing {
                self.navigationItem.rightBarButtonItem = nil
            }
            
            if !isEditing {
                self.navigationItem.rightBarButtonItem = addBarBtn
            }
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
        
        alert.addTextField { (textfield) in }
        
        let cancelAction = UIAlertAction(title: Constants.Alert.titleBtnCancel, style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: Constants.Alert.titleBtnConfirm, style: .default) { (action) in
            if let textfield = alert.textFields?[0], let title = textfield.text, !title.isEmpty {
                
                self.addCounterOnApi(title: title)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true, completion: nil)
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

        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action,indexPath)  in

            let counter = self.countersArray[indexPath.row]
            self.deleteCounterOnApi(id: counter.id)
        }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        
        if (!tableView.isEditing) {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        
        if (!tableView.isEditing) {
            self.navigationItem.rightBarButtonItem = addBarBtn
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
                    
                    if self.countersArray.count == 0 {
                        self.navigationItem.leftBarButtonItem?.isEnabled = false
                    }
                    
                    if self.countersArray.count > 0 {
                        self.navigationItem.leftBarButtonItem?.isEnabled = true
                    }
                    
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
                self.editBarBtn.isEnabled = true
                
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
                    
                    if self.tableView.isEditing && self.countersArray.count == 0 {
                        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
                        self.navigationItem.rightBarButtonItem = self.addBarBtn
                        self.navigationItem.leftBarButtonItem?.isEnabled = false
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



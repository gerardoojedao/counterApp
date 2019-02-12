//
//  ListCountersViewController.swift
//  CounterApp
//
//  Created by Gerardo Ojeda on 12-02-19.
//  Copyright © 2019 Gerardo Ojeda. All rights reserved.
//

import UIKit

class ListCountersViewController: UIViewController {

    let cellIdentifier = "cell"
    let apiClient = ApiManager()
    
    var editBarBtn: UIBarButtonItem!
    var addBarBtn: UIBarButtonItem!
    var tableView: UITableView!
    var totalNumberLabel: UILabel!
    
    var countersArray = [Counter]() {
        didSet {
            let total = countersArray.map({$0.count}).reduce(0, +)
            print(total)
            totalNumberLabel.text = "Total: " + String(describing: total)
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
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
        
        editBarBtn = UIBarButtonItem(title: Constants.BtnTitle.add.localized(), style: .plain, target: self, action: #selector(editCountersTapped(_:)))
        addBarBtn = UIBarButtonItem(title: Constants.BtnTitle.edit.localized(), style: .plain, target: self, action: #selector(addNewCounterTapped(_:)))
        self.navigationItem.leftBarButtonItem = editBarBtn
        self.navigationItem.rightBarButtonItem = addBarBtn
        
    }
    
    func setUpTableView() {

        tableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.view.addSubview(self.tableView)
    }
    
    func setUpToolbar() {
        
        totalNumberLabel = UILabel()
        totalNumberLabel.numberOfLines = 0
        totalNumberLabel.textAlignment = .center
        totalNumberLabel.text = "a"
        
        let titleView = UIBarButtonItem(customView: totalNumberLabel)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        self.toolbarItems = [flexibleSpace, titleView]
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func setTotal() {
        
        let total = countersArray.map({$0.count}).reduce(0, +)
        totalNumberLabel.text = "Text: " + String(describing: total)
    }

    @IBAction func editCountersTapped(_ sender: UIBarButtonItem) {
        
        addBarBtn.isEnabled = false
        
        apiClient.send(GetCounters()) { (response) in
            
            DispatchQueue.main.async {
                self.addBarBtn.isEnabled = true
                
                switch response {
                    
                case .success(let response):
                    print(response)
                    
                    self.countersArray = response
                    //self.tableView.reloadData()
                    //self.setTotal()
                    break
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
        }
    }
    
    @IBAction func addNewCounterTapped(_ sender: UIBarButtonItem) {
        
        editBarBtn.isEnabled = false
        
        apiClient.send(AddCounter(title: "dhjdg")) { (response) in
            
            DispatchQueue.main.async {
                self.editBarBtn.isEnabled = true
                
                switch response {
                    
                case .success(let response):
                    print(response)
                    
                    self.countersArray = response
                    self.tableView.reloadData()
                    self.setTotal()
                    break
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
        }
    }

}

extension ListCountersViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let counter = countersArray[indexPath.row]
        cell.textLabel?.text = counter.title
        
        return cell
    }
}

extension ListCountersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action,indexPath)  in

            let counter = self.countersArray[indexPath.row]
            
            self.apiClient.send(DeleteCounter(id: counter.id)) { (response) in
                
                DispatchQueue.main.async {
                    self.editBarBtn.isEnabled = true
                    
                    switch response {
                        
                    case .success(let response):
                        print(response)
                        
                        self.countersArray = response
                        self.tableView.reloadData()
                        self.setTotal()
                        break
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        break
                    }
                }
            }
        }
        
        return [deleteAction]
    }
    
}



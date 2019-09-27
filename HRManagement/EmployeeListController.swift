//
//  EmployeeListController.swift
//  HRManagement
//
//  Created by Tri Nguyen on 14/09/2019.
//  Copyright © 2019 Tri Nguyen. All rights reserved.
//

import UIKit

class EmployeeListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    public var arrSearchEmpIndex:[Int] = [Int]()
    
    public var isSearch = false
    public var curSearchValue = ""
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tvEmployeeList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        tvEmployeeList.tableHeaderView = searchController.searchBar
        
        if curSearchValue != "" {
            searchController.searchBar.text = curSearchValue
            arrSearchEmpIndex = [Int]()
            for i in 0..<ViewController.arrEmployee.count {
                if ViewController.arrEmployee[i].getName().contains(curSearchValue) {
                    arrSearchEmpIndex.append(i)
                }
            }
        } else {
            searchController.searchBar.text = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnDelete(_ sender: UIButton) {
        let selectedIndex : Int = sender.tag
        ViewController.arrEmployee.remove(at: selectedIndex)
        ViewController.save()
        ViewController.alertMessage(self, strTitle: "Alert", strMessage: "Record deleted successfully")
        tvEmployeeList.reloadData()
    }
    
    @IBAction func btnEdit(_ sender: UIButton) {
        //self.performSegue(withIdentifier: "editSegue", sender: sender)
        let selectedIndex : Int = sender.tag
        
        let naviVC = (self.navigationController)! as UINavigationController
        let n: Int! = naviVC.viewControllers.count
        
        if n < 2 {
            return
        }
        
        let mainVC = self.navigationController?.viewControllers[n-2] as! ViewController
        mainVC.isEdit = true
        mainVC.currentEmployee = ViewController.arrEmployee[selectedIndex]
        
        mainVC.display(e: mainVC.currentEmployee)
        mainVC.changeEditState(on: true)
        
        naviVC.popViewController(animated: true)
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.text != "" {
            return arrSearchEmpIndex.count
        }
        return ViewController.arrEmployee.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EmployeeListCell = tableView.dequeueReusableCell(withIdentifier: "EmployeeListCell", for: indexPath) as! EmployeeListCell
        
        var index = -1
        if searchController.searchBar.text != "" {
            index = arrSearchEmpIndex[indexPath.row]
        } else {
            index = indexPath.row
        }
        
        if let empRef = ViewController.arrEmployee[index] as? FullTime {
            cell.txtNameAge?.text = "Name : \(empRef.getName()), Age : \(empRef.getAge())"
            cell.txtDOBCountry?.text = "DOB : \(empRef.getDOB()), Country : \(empRef.getCountry())"
            cell.txtPayroll?.text = "Salary : \(empRef.salary), Bonus : \(empRef.bonus)"
        }
        else if let empRef = ViewController.arrEmployee[index] as? PartTime {
            cell.txtNameAge?.text = "Name : \(empRef.getName()), Age : \(empRef.getAge())"
            cell.txtDOBCountry?.text = "DOB : \(empRef.getDOB()), Country : \(empRef.getCountry())"
            cell.txtPayroll?.text = "Hours : \(empRef.hoursWorked), Rate : \(empRef.rate)"
        }
        else if let empRef = ViewController.arrEmployee[index] as? Intern {
            cell.txtNameAge?.text = "Name : \(empRef.getName()), Age : \(empRef.getAge())"
            cell.txtDOBCountry?.text = "DOB : \(empRef.getDOB()), Country : \(empRef.getCountry())"
            cell.txtPayroll?.text = "School : \(empRef.collegeName)"
        }
        
        if (ViewController.arrEmployee[index].vehicle_owned != nil) {
            cell.txtVehicle?.text = "Vehicle Plate: \((ViewController.arrEmployee[index].vehicle_owned?.plateNumber)!), Make : \((ViewController.arrEmployee[index].vehicle_owned?.make)!)"
        } else {
            cell.txtVehicle?.text = "No Vehicle Info"
        }
        cell.btnEdit.tag = index
        cell.btnDelete.tag = index
        
        return cell
    }
    
    func filterContentForSearchText(_ searchText: String) {
        tvEmployeeList.reloadData()
    }
}

extension EmployeeListController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        arrSearchEmpIndex = [Int]()
        for i in 0..<ViewController.arrEmployee.count {
            if ViewController.arrEmployee[i].getName() == searchBar.text {
                arrSearchEmpIndex.append(i)
            }
        }
        tvEmployeeList.reloadData()
    }
}

extension EmployeeListController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        arrSearchEmpIndex = [Int]()
        for i in 0..<ViewController.arrEmployee.count {
            if ViewController.arrEmployee[i].getName().contains(searchController.searchBar.text!) {
                arrSearchEmpIndex.append(i)
            }
        }
        tvEmployeeList.reloadData()
    }
}


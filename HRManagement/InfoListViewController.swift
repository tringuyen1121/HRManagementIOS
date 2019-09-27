//
//  InfoListViewController.swift
//  HRManagement
//
//  Created by Tri Nguyen on 14/09/2019.
//  Copyright © 2019 Tri Nguyen. All rights reserved.
//

import UIKit

class InfoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    public var veiwType : Int = 0
    
    @IBOutlet weak var txtTotalPayroll: UILabel!
    @IBOutlet weak var tvInfoList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if veiwType == 0 {
            self.navigationItem.title = "Calculation Payroll"
            
            var totalPR = 0
            for i in 0..<ViewController.arrEmployee.count {
                totalPR = totalPR + ViewController.arrEmployee[i].calcEaringings()
            }
            
            let doubleValue = Double(totalPR)
            let formatter = NumberFormatter()
            formatter.currencyCode = "USD"
            formatter.currencySymbol = "$"
            formatter.numberStyle = .currencyAccounting
            let strTotalPR = formatter.string(from: NSNumber(value: doubleValue))
            
            txtTotalPayroll.text = "\n\nTotal Payroll : \((strTotalPR)!)"
            txtTotalPayroll.backgroundColor = UIColor(red: 205/255, green: 133/255, blue: 63/255, alpha: 1.0)
            txtTotalPayroll.numberOfLines = 4
            txtTotalPayroll.sizeToFit()
            
            let h = NSLayoutConstraint (item: self.txtTotalPayroll!, attribute: .height,
                                        relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            let t = NSLayoutConstraint(item: self.txtTotalPayroll!, attribute: .top,
                                       relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 25.0)
            let r = NSLayoutConstraint(item: self.txtTotalPayroll!, attribute: .trailing,
                                       relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
            let l = NSLayoutConstraint(item: self.txtTotalPayroll!, attribute: .leading,
                                       relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0.0)
            self.view.addConstraints([h, t,l,r])
        } else {
            self.navigationItem.title = "Calculation Year"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewController.arrEmployee.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "InfoListCell", for: indexPath) as UITableViewCell
        
        var txt = ""
        if veiwType == 0 {
            let doubleValue = Double(ViewController.arrEmployee[indexPath.row].calcEaringings())
            let formatter = NumberFormatter()
            formatter.currencyCode = "USD"
            formatter.currencySymbol = "$"
            formatter.numberStyle = .currencyAccounting
            let payroll = formatter.string(from: NSNumber(value: doubleValue))
            
            txt = "Name: \(ViewController.arrEmployee[indexPath.row].getName())"
            txt += "\nPayroll: \((payroll)!)"
        } else {
            txt = "Name: \(ViewController.arrEmployee[indexPath.row].getName())"
            txt += "\nAge: \(String(ViewController.arrEmployee[indexPath.row].getAge()))"
            txt += ", DOB Year: \(String(ViewController.arrEmployee[indexPath.row].calcBirthYear()))"
        }
        cell.textLabel?.text = txt
        return cell
    }
    
}


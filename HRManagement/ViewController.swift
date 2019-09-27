//
//  ViewController.swift
//  HRManagement
//
//  Created by Tri Nguyen on 13/09/2019.
//  Copyright © 2019 Tri Nguyen. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController {
    
    public static var isLoad : Bool = false
    public var isEdit : Bool = false
    
    public static var arrEmployee:[Employee] = [Employee]()
    public var currentEmployee : Employee? = nil
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    
    @IBOutlet weak var lbSalaryHoursSchool: UILabel!
    @IBOutlet weak var lbBonusRate: UILabel!
    
    @IBOutlet weak var txtSalaryHoursSchool: UITextField!
    @IBOutlet weak var txtBonusRate: UITextField!
    
    @IBOutlet weak var txtPlate: UITextField!
    @IBOutlet weak var txtMake: UITextField!
    
    @IBOutlet weak var ctrlEmpType: UISegmentedControl!
    
    @IBOutlet weak var btnAddChange: UIButton!
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if !ViewController.isLoad {
            load()
        }
        
        if isEdit {
            display(e: currentEmployee)
            changeEditState(on: true)
        }
        else {
            changeEditState(on: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !ViewController.isLoad {
            ViewController.save()
        }
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeEmptype(_ sender: UISegmentedControl) {
        if isEdit {
            clearField(shouldClearName: false)
            changeEditState(on: false)
        }
        switch sender.selectedSegmentIndex {
        case 1:
            lbBonusRate.isHidden = false
            txtBonusRate.isHidden = false
            lbSalaryHoursSchool.text = "Hours"
            lbBonusRate.text = "Rate"
            txtSalaryHoursSchool.placeholder = "Hours"
            txtBonusRate.placeholder = "Rate"
            break
        case 2:
            lbBonusRate.isHidden = true
            txtBonusRate.isHidden = true
            lbSalaryHoursSchool.text = "University or College"
            txtSalaryHoursSchool.placeholder = "School"
            break
        default:
            lbBonusRate.isHidden = false
            txtBonusRate.isHidden = false
            lbSalaryHoursSchool.text = "Salary"
            lbBonusRate.text = "Bonus"
            txtSalaryHoursSchool.placeholder = "Salary"
            txtBonusRate.placeholder = "Bonus"
            break
        }
    }
    
    @IBAction func btnDOBPicker(_ sender: UIButton) {
        DOBPickerDialog().show("DOBPicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: nil) { (dob) in
            if let dt = dob {
                self.txtDOB.text = "\(dt)"
            }
        }
    }
    
    @IBAction func btnCountryPicker(_ sender: UIButton) {
        CountryPickerDialog().show("CountryPicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultCountry: "Afghanistan") { (country) in
            if let ct = country {
                self.txtCountry.text = "\(ct)"
            }
        }
    }
    
    @IBAction func btnClear(_ sender: UIButton) {
        clearField(shouldClearName: false)
        changeEditState(on: false)
    }
    
    private func clearField(shouldClearName : Bool) {
        if !shouldClearName {
            txtName.text = ""
            txtAge.text = ""
            txtDOB.text = ""
            txtCountry.text = ""
            txtSalaryHoursSchool.text = ""
            txtBonusRate.text = ""
            txtPlate.text = ""
            txtMake.text = ""
        }
    }
    
    public func changeEditState(on:Bool) {
        if on {
            isEdit = true
            btnAddChange.setTitle("Change",for: .normal)
        } else {
            isEdit = false
            currentEmployee = nil
            btnAddChange.setTitle("Add",for: .normal)
        }
    }
    
    @IBAction func btnAddChange(_ sender: UIButton) {
        var msg = ""
        if isEdit {
            if let empRef = currentEmployee as? FullTime {
                if !isValidRecord(employeeType: 0) {
                    return
                }
                
                empRef.setName(txtName.text!)
                empRef.setAge(Int(txtAge.text!)!)
                empRef.setDOB(txtDOB.text!)
                empRef.setCountry(txtCountry.text!)
                empRef.salary = Int(txtSalaryHoursSchool.text!)!
                empRef.bonus = Int(txtBonusRate.text!)!
                
                msg = "FullTime Employee Record is changed"
            }
            else if let empRef = currentEmployee as? PartTime {
                if !isValidRecord(employeeType: 1) {
                    return
                }
                
                empRef.setName(txtName.text!)
                empRef.setAge(Int(txtAge.text!)!)
                empRef.setDOB(txtDOB.text!)
                empRef.setCountry(txtCountry.text!)
                empRef.hoursWorked = Int(txtSalaryHoursSchool.text!)!
                empRef.rate = Int(txtBonusRate.text!)!
                
                msg = "PartTime Employee Record is changed"
            }
            else if let empRef = currentEmployee as? Intern {
                if !isValidRecord(employeeType: 2) {
                    return
                }
                
                empRef.setName(txtName.text!)
                empRef.setAge(Int(txtAge.text!)!)
                empRef.setDOB(txtDOB.text!)
                empRef.setCountry(txtCountry.text!)
                empRef.collegeName = txtSalaryHoursSchool.text!
                
                msg = "Intern Employee Record is changed"
            }
            
            if (currentEmployee!.vehicle_owned != nil) {
                currentEmployee?.vehicle_owned?.plateNumber = txtPlate.text!
                currentEmployee?.vehicle_owned?.make = txtMake.text!
            }
        } else {
            var v : Vehicle? = nil
            if (!((txtPlate.text?.isEmpty)!)) && (!(txtMake.text?.isEmpty)!) {
                v = Vehicle(pPlate: txtPlate.text!, pMake: txtMake.text!)
            }
            if ctrlEmpType.selectedSegmentIndex == 0 {
                // FullTime
                if !isValidRecord(employeeType: 0) {
                    return
                }
                
                let ft : FullTime = FullTime(name: txtName.text!, age: Int(txtAge.text!)!, DOB: txtDOB.text!, country: txtCountry.text!, salary: Int(txtSalaryHoursSchool.text!)!, bonus: Int(txtBonusRate.text!)!, pPV: v)
                
                ViewController.arrEmployee.append(ft)
                currentEmployee = ft;
                changeEditState(on: true)
                
                msg = "FullTime Employee Record is added"
            }
            else if ctrlEmpType.selectedSegmentIndex == 1 {
                // PartTime
                if !isValidRecord(employeeType: 1) {
                    return
                }
                
                let pt : PartTime = PartTime(name: txtName.text!, age: Int(txtAge.text!)!, DOB: txtDOB.text!, country: txtCountry.text!, hoursWorked: Int(txtSalaryHoursSchool.text!)!, rate: Int(txtBonusRate.text!)!, pPV: v)
                
                ViewController.arrEmployee.append(pt)
                currentEmployee = pt;
                changeEditState(on: true)
                
                msg = "PartTime Employee Record is added"
            }
            else if ctrlEmpType.selectedSegmentIndex == 2 {
                // Intern
                if !isValidRecord(employeeType: 2) {
                    return
                }
                
                let it : Intern = Intern(name: txtName.text!, age: Int(txtAge.text!)!, DOB: txtDOB.text!, country: txtCountry.text!, collegeName: txtSalaryHoursSchool.text!, pPV: v)
                
                ViewController.arrEmployee.append(it)
                currentEmployee = it;
                changeEditState(on: true)
                
                msg = "Intern Employee Record is added"
            }
        }
        ViewController.save()
        if(msg != ""){
            ViewController.alertMessage(self, strTitle: "Alert", strMessage: msg)
        }
    }
    
    public func isValidRecord (employeeType : Int) -> Bool {
        var isValid : Bool = true
        var msg : String = ""
        
        if txtName.text == "" {
            msg = "Please fill Employee's Name "
            isValid = false
        }
        else if txtAge.text == "" {
            msg = "Please fill Employee's Age "
            isValid = false
        }
        else if txtDOB.text == "" {
            msg = "Please fill Employee's Date of Birth "
            isValid = false
        }
        else if txtCountry.text == "" {
            msg = "Please fill Employee's Country "
            isValid = false
        }
        else if txtSalaryHoursSchool.text == "" {
            if employeeType == 1 {
                msg = "Please fill Employee's Hours "
            }
            else if employeeType == 2 {
                msg = "Please fill Employee's School "
            }
            else {
                msg = "Please fill Employee's Salary "
            }
            isValid = false
        }
        else if employeeType != 2 && txtBonusRate.text  == "" {
            if employeeType == 1 {
                msg = "Please fill Employee's Bonus "
            }
            else {
                msg = "Please fill Employee's Rate "
            }
            isValid = false
        }
        
        if(!isValid) {
            ViewController.alertMessage(self, strTitle: "Alert", strMessage: msg)
        }
        
        return isValid
    }
    
    public func display (e : Employee?) {
        navBarTitle.title = "Hello"
        clearField(shouldClearName: false)
        if let empRef = e as? FullTime {
            ctrlEmpType.selectedSegmentIndex = 0
            txtName.text = empRef.getName()
            txtAge.text = String(empRef.getAge())
            txtDOB.text = String(empRef.getDOB())
            txtCountry.text = String(empRef.getCountry())
            txtSalaryHoursSchool.text = String(empRef.salary)
            txtBonusRate.text = String(empRef.bonus)
        } else if let empRef = e as? PartTime {
            ctrlEmpType.selectedSegmentIndex = 1
            txtName.text = empRef.getName()
            txtAge.text = String(empRef.getAge())
            txtDOB.text = String(empRef.getDOB())
            txtCountry.text = String(empRef.getCountry())
            txtSalaryHoursSchool.text = String(empRef.hoursWorked)
            txtBonusRate.text = String(empRef.rate)
        } else if let empRef = e as? Intern {
            ctrlEmpType.selectedSegmentIndex = 2
            txtName.text = empRef.getName()
            txtAge.text = String(empRef.getAge())
            txtDOB.text = String(empRef.getDOB())
            txtCountry.text = String(empRef.getCountry())
            txtSalaryHoursSchool.text = empRef.collegeName
        }
        
        if (e?.vehicle_owned != nil) {
            txtPlate.text = e?.vehicle_owned?.plateNumber
            txtMake.text = e?.vehicle_owned?.make
        }
    }
    
    @IBAction func btnCalcPayroll(sender: UIButton) {
        sender.tag = 0
        self.performSegue(withIdentifier: "payrollSegue", sender: sender)
    }
    
    @IBAction func btnCalYear(sender: UIButton) {
        //sender.tag = 1
        //self.performSegue(withIdentifier: "payrollSegue", sender: sender)
        if txtDOB.text == "" {
            ViewController.alertMessage(self, strTitle: "Alert", strMessage: "Please fill Employee's Date of Birth ")
            return
        }
        let dateArr = txtDOB.text?.components(separatedBy: "-")
        let year = dateArr?[0]
        
        let date = Date()
        let calendar = Calendar.current
        let currentDate = calendar.dateComponents([.year, .month, .day], from: date)
        let age = currentDate.year! - Int(year!)!
        txtAge.text = String(age)
    }
    
    @IBAction func btnSearchByName(_ sender: UIButton) {
        sender.tag = 1
        self.performSegue(withIdentifier: "viewSegue", sender: sender)
    }
    
    @IBAction func btnList(_ sender: UIButton) {
        sender.tag = 0
        self.performSegue(withIdentifier: "viewSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "payrollSegue" {
            let button : UIButton = sender as! UIButton
            let listVC : InfoListViewController = segue.destination as! InfoListViewController
            listVC.veiwType = button.tag
        } else if segue.identifier == "viewSegue" {
            let button : UIButton = sender as! UIButton
            let listVC : EmployeeListController = segue.destination as! EmployeeListController
            if button.tag == 1 {
                listVC.isSearch = true
                let nameToSearch = txtName.text
                if nameToSearch != nil && nameToSearch != "" {
                    listVC.curSearchValue = nameToSearch!
                }
            }
        }
    }
    
    public static func alertMessage (_ viewcontroller: UIViewController, strTitle: String, strMessage: String) {
        let controller = UIAlertController(title: strTitle, message: strMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: UIAlertAction.Style.default)
        controller.addAction(action)
        viewcontroller.present(controller,animated: true)
    }
    
    public static func save() {
        if !ViewController.isLoad {
            return;
        }
        do {
            let data  = try NSKeyedArchiver.archivedData(withRootObject: ViewController.arrEmployee, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey:"arrEmploy" )
        } catch {
            os_log("Failed to save employee...", log: OSLog.default, type: .error)
        }
       
    }
    
    public func load() {
        if ViewController.isLoad {
            return;
        }
        if let data = UserDefaults.standard.object(forKey: "arrEmploy") as? NSData {
            do {
                ViewController.arrEmployee = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: data as Data) as! [Employee]
                ViewController.isLoad = true
            } catch {
                os_log("Failed to load employee...", log: OSLog.default, type: .error)
            }
        }
    }
}



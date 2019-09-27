//
//  FullTime.swift
//  HRManagement
//
//  Created by Tri Nguyen on 14/09/2019.
//  Copyright © 2019 Tri Nguyen. All rights reserved.
//

import Foundation

open class FullTime : Employee {
    
    open var salary : Int = 0
    open var bonus : Int = 0
    
    override init () {
        self.salary = 0
        self.bonus = 0
        super.init()
    }
    
    init (name : String, age : Int, DOB : String, country : String, salary : Int, bonus : Int, pPV : Vehicle?) {
        super.init(pName : name, pAge : age, pDOB : DOB, pCountry : country, pV : pPV)
        self.salary = salary;
        self.bonus = bonus;
    }
    
    init (name : String, age : Int, DOB : String, country : String, salary : Int, bonus : Int, pPPlate : String, pPMake : String) {
        super.init (pName : name, pAge : age, pDOB : DOB, pCountry : country, pPlate: pPPlate, pMake : pPMake)
        self.salary = salary;
        self.bonus = bonus;
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.salary = Int(aDecoder.decodeInt32(forKey: "salary"))
        self.bonus = Int(aDecoder.decodeInt32(forKey: "bonus"))
    }
    
    override public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.salary, forKey: "salary")
        aCoder.encode(self.bonus, forKey: "bonus")
        super.encode(with: aCoder)
    }
    
    override open func calcEaringings() -> Int {
        return (salary + bonus)
    }
    
    override open func displayData() {
        super.displayData();
        print ("Salary: \(salary)")
        print ("Bonus: \(bonus)")
    }
    
}


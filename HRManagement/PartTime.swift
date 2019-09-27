//
//  PartTime.swift
//  HRManagement
//
//  Created by Tri Nguyen on 14/09/2019.
//  Copyright © 2019 Tri Nguyen. All rights reserved.
//

import Foundation

open class PartTime : Employee {
    
    open var hoursWorked : Int = 0
    open var rate : Int = 0
    
    override init () {
        super.init()
        hoursWorked = 0
        rate = 0
    }
    
    init (name : String, age : Int, DOB : String, country : String, hoursWorked : Int, rate : Int, pPV : Vehicle?) {
        super.init(pName : name, pAge : age, pDOB : DOB, pCountry : country, pV : pPV)
        self.hoursWorked = hoursWorked;
        self.rate = rate;
    }
    
    init (name : String, age : Int, DOB : String, country : String, hoursWorked : Int, rate : Int, pPPlate : String, pPMake : String) {
        super.init (pName : name, pAge : age, pDOB : DOB, pCountry : country, pPlate: pPPlate, pMake : pPMake)
        self.hoursWorked = hoursWorked;
        self.rate = rate;
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hoursWorked = Int(aDecoder.decodeInt32(forKey: "hoursWorked"))
        self.rate = Int(aDecoder.decodeInt32(forKey: "rate"))
    }
    
    override public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.hoursWorked, forKey: "hoursWorked")
        aCoder.encode(self.rate, forKey: "rate")
        super.encode(with: aCoder)
    }
    
    override open func calcEaringings() -> Int {
        return (hoursWorked * rate)
    }
    
    override open func displayData() {
        super.displayData();
        print ("HoursWorked: \(hoursWorked)")
        print ("Rate: \(rate)")
    }
    
}


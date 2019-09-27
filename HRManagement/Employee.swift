//
//  Employee.swift
//  HRManagement
//
//  Created by Tri Nguyen on 14/09/2019.
//  Copyright © 2019 Tri Nguyen. All rights reserved.
//

import Foundation

open class Employee : NSObject, NSCoding, IDisplayable {
    
    fileprivate var name : String
    fileprivate var age : Int
    fileprivate var DOB : String
    fileprivate var country : String
    
    open var vehicle_owned : Vehicle?
    
    open func getName () -> String { return self.name }
    open func setName (_ pName : String) { self.name = pName }
    
    open func getAge () -> Int { return self.age }
    open func setAge (_ pAge : Int) {
        if pAge > 0 {
            self.age = pAge
        } else {
            print("Invalid Age")
        }
    }
    
    open func getDOB () -> String { return self.DOB }
    open func setDOB (_ pDOB : String) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        if df.date(from: pDOB) != nil {
            self.DOB = pDOB
        } else {
            print("Invalid Date")
        }
    }
    
    open func getCountry () -> String { return self.country }
    open func setCountry (_ pCountry : String) { self.country = pCountry }
    
    override init() {
        self.name = ""
        self.age = 0
        self.DOB = ""
        self.country = ""
        vehicle_owned = nil
    }
    
    init (pName : String, pAge : Int, pDOB : String, pCountry : String, pV : Vehicle?) {
        self.name = pName
        self.age = pAge
        self.DOB = pDOB
        self.country = pCountry
        self.vehicle_owned = pV
    }
    
    init (pName : String, pAge : Int, pDOB : String, pCountry : String, pPlate: String, pMake : String) {
        self.name = pName
        self.age = pAge
        self.DOB = pDOB
        self.country = pCountry
        self.vehicle_owned = Vehicle(pPlate: pPlate, pMake: pMake)
    }
    
    required public init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "Name") as! String
        self.age = Int(aDecoder.decodeInt32(forKey: "Age"))
        self.DOB = aDecoder.decodeObject(forKey: "DOB") as! String
        self.country = aDecoder.decodeObject(forKey: "Country") as! String
        vehicle_owned = aDecoder.decodeObject(forKey: "vehicle_owned") as? Vehicle
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "Name")
        aCoder.encode(self.age, forKey: "Age")
        aCoder.encode(self.DOB, forKey: "DOB")
        aCoder.encode(self.country, forKey: "Country")
        aCoder.encode(vehicle_owned, forKey: "vehicle_owned")
    }
    
    open func calcBirthYear() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        return (components.year! - self.age)
    }
    
    open func calcEaringings() -> Int {
        return 1000
    }
    
    open func displayData() {
        print ("Name: \(self.name)")
        print ("Age: \(self.age)")
        print ("Date of Birth: \(self.DOB)")
        print ("Country: \(self.country)")
        if vehicle_owned != nil {
            vehicle_owned?.displayData()
        } else {
            print("No vehicle registed")
        }
    }
}


//
//  Vehicle.swift
//  HRManagement
//
//  Created by Tri Nguyen on 14/09/2019.
//  Copyright © 2019 Tri Nguyen. All rights reserved.
//

import Foundation

open class Vehicle : NSObject, NSCoding, IDisplayable {
    
    open var plateNumber : String
    open var make : String
    
    override init () {
        self.plateNumber = ""
        self.make = ""
    }
    
    init (pPlate : String, pMake : String){
        self.plateNumber = pPlate
        self.make = pMake
    }
    
    required public init(coder aDecoder: NSCoder) {
        self.plateNumber = aDecoder.decodeObject(forKey: "plateNumber") as! String
        self.make = aDecoder.decodeObject(forKey: "make") as! String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.plateNumber, forKey: "plateNumber")
        aCoder.encode(self.make, forKey: "make")
    }
    
    open func displayData() {
        print("Vichile Plate \(self.plateNumber) ")
        print("Vichile Make \(self.make) ")
    }
    
}


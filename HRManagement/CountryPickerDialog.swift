//
//  CountryPickerDialog.swift
//  HRManagement
//
//  Created by Tri Nguyen on 15/09/2019.
//  Copyright © 2019 Tri Nguyen. All rights reserved.
//

import Foundation
import UIKit

private extension Selector {
    static let buttonTapped = #selector(CountryPickerDialog.buttonTapped)
    static let deviceOrientationDidChange = #selector(CountryPickerDialog.deviceOrientationDidChange)
}

open class CountryPickerDialog: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    public typealias CountryPickerCallback = ( String? ) -> Void
    
    //var pickerDataSource : [String] = ["Korea", "USA", "Canada", "Taiwan", "China", "India", "Japan", "Brazil"];
    var countryList : [String] = []
    
    // MARK: - Constants
    private let kDatePickerDialogDefaultButtonHeight:       CGFloat = 50
    private let kDatePickerDialogDefaultButtonSpacerHeight: CGFloat = 1
    private let kDatePickerDialogCornerRadius:              CGFloat = 7
    private let kDatePickerDialogDoneButtonTag:             Int     = 1
    
    // MARK: - Views
    private var dialogView:   UIView!
    private var titleLabel:   UILabel!
    open var countryPicker:    UIPickerView!
    private var cancelButton: UIButton!
    private var doneButton:   UIButton!
    
    // MARK: - Variables
    private var callback:       CountryPickerCallback?
    private var defaultCountry:   String?
    
    // MARK: - Dialog initialization
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        setupView()
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.dialogView = createContainerView()
        
        self.dialogView!.layer.shouldRasterize = true
        self.dialogView!.layer.rasterizationScale = UIScreen.main.scale
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        self.dialogView!.layer.opacity = 0.5
        self.dialogView!.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1)
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        self.addSubview(self.dialogView!)
        
        self.countryPicker.dataSource = self
        self.countryPicker.delegate = self
        
        
        if let path = Bundle.main.path(forResource: "Country", ofType: "plist") {
            countryList = (NSArray(contentsOfFile: path) as! [String])
            //            for country in countries {
            //                countryList.append(country);
            //            }
        }
    }
    
    /// Handle device orientation changes
    @objc func deviceOrientationDidChange(_ notification: Notification) {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        let screenSize = countScreenSize()
        let dialogSize = CGSize(width: 300, height: 230 + kDatePickerDialogDefaultButtonHeight + kDatePickerDialogDefaultButtonSpacerHeight)
        dialogView.frame = CGRect(x: (screenSize.width - dialogSize.width) / 2, y: (screenSize.height - dialogSize.height) / 2, width: dialogSize.width, height: dialogSize.height)
    }
    
    /// Create the dialog view, and animate opening the dialog
    open func show(_ title: String, doneButtonTitle: String = "Done", cancelButtonTitle: String = "Cancel",
                   defaultCountry: String?, callback: @escaping CountryPickerCallback) {
        self.titleLabel.text = title
        self.doneButton.setTitle(doneButtonTitle, for: .normal)
        self.cancelButton.setTitle(cancelButtonTitle, for: .normal)
        self.callback = callback
        self.defaultCountry = defaultCountry
        
        var defaultRowIndex = 0
        if self.defaultCountry != nil {
            defaultRowIndex = countryList.firstIndex(of: self.defaultCountry!)!
        }
        countryPicker.selectRow(defaultRowIndex, inComponent: 0, animated: false)
        
        /* Add dialog to main window */
        guard let appDelegate = UIApplication.shared.delegate else { fatalError() }
        guard let window = appDelegate.window else { fatalError() }
        window?.addSubview(self)
        window?.bringSubviewToFront(self)
        window?.endEditing(true)
        
        NotificationCenter.default.addObserver(self, selector: .deviceOrientationDidChange, name: UIDevice.orientationDidChangeNotification, object: nil)
        
        /* Anim */
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
                self.dialogView!.layer.opacity = 1
                self.dialogView!.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
        )
    }
    
    /// Dialog close animation then cleaning and removing the view from the parent
    private func close() {
        NotificationCenter.default.removeObserver(self)
        
        let currentTransform = self.dialogView.layer.transform
        
        let startRotation = (self.value(forKeyPath: "layer.transform.rotation.z") as? NSNumber) as? Double ?? 0.0
        let rotation = CATransform3DMakeRotation((CGFloat)(-startRotation + Double.pi * 270 / 180), 0, 0, 0)
        
        self.dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1))
        self.dialogView.layer.opacity = 1
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [],
            animations: {
                self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                self.dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6, 0.6, 1))
                self.dialogView.layer.opacity = 0
        }) { (finished) in
            for v in self.subviews {
                v.removeFromSuperview()
            }
            
            self.removeFromSuperview()
            self.setupView()
        }
    }
    
    /// Creates the container view here: create the dialog, then add the custom content and buttons
    private func createContainerView() -> UIView {
        let screenSize = countScreenSize()
        let dialogSize = CGSize(
            width: 300,
            height: 230
                + kDatePickerDialogDefaultButtonHeight
                + kDatePickerDialogDefaultButtonSpacerHeight)
        
        // For the black background
        self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        
        // This is the dialog's container; we attach the custom content and the buttons to this one
        let dialogContainer = UIView(frame: CGRect(x: (screenSize.width - dialogSize.width) / 2, y: (screenSize.height - dialogSize.height) / 2, width: dialogSize.width, height: dialogSize.height))
        
        // First, we style the dialog to match the iOS8 UIAlertView >>>
        let gradient: CAGradientLayer = CAGradientLayer(layer: self.layer)
        gradient.frame = dialogContainer.bounds
        gradient.colors = [UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1).cgColor,
                           UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1).cgColor,
                           UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1).cgColor]
        
        let cornerRadius = kDatePickerDialogCornerRadius
        gradient.cornerRadius = cornerRadius
        dialogContainer.layer.insertSublayer(gradient, at: 0)
        
        dialogContainer.layer.cornerRadius = cornerRadius
        dialogContainer.layer.borderColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1).cgColor
        dialogContainer.layer.borderWidth = 1
        dialogContainer.layer.shadowRadius = cornerRadius + 5
        dialogContainer.layer.shadowOpacity = 0.1
        dialogContainer.layer.shadowOffset = CGSize(width: 0 - (cornerRadius + 5) / 2, height: 0 - (cornerRadius + 5) / 2)
        dialogContainer.layer.shadowColor = UIColor.black.cgColor
        dialogContainer.layer.shadowPath = UIBezierPath(roundedRect: dialogContainer.bounds, cornerRadius: dialogContainer.layer.cornerRadius).cgPath
        
        // There is a line above the button
        let lineView = UIView(frame: CGRect(x: 0, y: dialogContainer.bounds.size.height - kDatePickerDialogDefaultButtonHeight - kDatePickerDialogDefaultButtonSpacerHeight, width: dialogContainer.bounds.size.width, height: kDatePickerDialogDefaultButtonSpacerHeight))
        lineView.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
        dialogContainer.addSubview(lineView)
        
        //Title
        self.titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 280, height: 30))
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        dialogContainer.addSubview(self.titleLabel)
        
        self.countryPicker = UIPickerView(frame: CGRect(x: 0, y: 30, width: 0, height: 0))
        self.countryPicker.autoresizingMask = .flexibleRightMargin
        self.countryPicker.frame.size.width = 300
        self.countryPicker.frame.size.height = 216
        dialogContainer.addSubview(self.countryPicker)
        
        // Add the buttons
        addButtonsToView(container: dialogContainer)
        
        return dialogContainer
    }
    
    /// Add buttons to container
    private func addButtonsToView(container: UIView) {
        let buttonWidth = container.bounds.size.width / 2
        
        let leftButtonFrame = CGRect(
            x: 0,
            y: container.bounds.size.height - kDatePickerDialogDefaultButtonHeight,
            width: buttonWidth,
            height: kDatePickerDialogDefaultButtonHeight
        )
        let rightButtonFrame = CGRect(
            x: buttonWidth,
            y: container.bounds.size.height - kDatePickerDialogDefaultButtonHeight,
            width: buttonWidth,
            height: kDatePickerDialogDefaultButtonHeight
        )
        
        let interfaceLayoutDirection = UIApplication.shared.userInterfaceLayoutDirection
        let isLeftToRightDirection = interfaceLayoutDirection == .leftToRight
        
        self.cancelButton = UIButton(type: .custom) as UIButton
        self.cancelButton.frame = isLeftToRightDirection ? leftButtonFrame : rightButtonFrame
        self.cancelButton.setTitleColor(UIColor(red: 0, green: 0.5, blue: 1, alpha: 1), for: .normal)
        self.cancelButton.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5), for: .highlighted)
        self.cancelButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 14)
        self.cancelButton.layer.cornerRadius = kDatePickerDialogCornerRadius
        self.cancelButton.addTarget(self, action: .buttonTapped, for: .touchUpInside)
        container.addSubview(self.cancelButton)
        
        self.doneButton = UIButton(type: .custom) as UIButton
        self.doneButton.frame = isLeftToRightDirection ? rightButtonFrame : leftButtonFrame
        self.doneButton.tag = kDatePickerDialogDoneButtonTag
        self.doneButton.setTitleColor(UIColor(red: 0, green: 0.5, blue: 1, alpha: 1), for: .normal)
        self.doneButton.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5), for: .highlighted)
        self.doneButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 14)
        self.doneButton.layer.cornerRadius = kDatePickerDialogCornerRadius
        self.doneButton.addTarget(self, action: .buttonTapped, for: .touchUpInside)
        container.addSubview(self.doneButton)
    }
    
    @objc func buttonTapped(sender: UIButton!) {
        if sender.tag == kDatePickerDialogDoneButtonTag {
            self.callback?(countryList[countryPicker.selectedRow(inComponent: 0)]);
        } else {
            self.callback?(nil)
        }
        
        close()
    }
    
    // MARK: - Helpers
    
    /// Count and return the screen's size
    func countScreenSize() -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        return CGSize(width: screenWidth, height: screenHeight)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryList.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryList[row];
    }
}


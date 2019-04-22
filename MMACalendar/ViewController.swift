//
//  ViewController.swift
//  MMACalendar
//
//  Created by Patrick Doyle on 4/21/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var calendarList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarPicker.delegate = self
        self.calendarPicker.dataSource = self
        loadWebpage()
    }
    
    @IBOutlet weak var ufcSwitch: UISwitch!
    
    
    @IBOutlet weak var bellatorSwitch: UISwitch!
    
    
    @IBOutlet weak var chooseCalendarButton: UIButton!
    
    @IBAction func chooseCalendarButtonPressed(_ sender: Any) {
        initializeEventStore(viewController: self)
    }
    
    @IBOutlet weak var calendarPicker: UIPickerView!
    
    //Calendar Picker View Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return calendarList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        self.view.endEditing(true)
        return NSAttributedString(string: calendarList[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        chooseCalendarButton.setTitle(calendarList[row], for: .normal)
        self.calendarPicker.isHidden = true
    }
    
    func updateCalendarData(calendarList: [String]){
        self.calendarList = calendarList
        self.calendarPicker.reloadAllComponents()
        self.calendarPicker.isHidden = false
    }
    
    
}



//
//  ViewController.swift
//  MMACalendar
//
//  Created by Patrick Doyle on 4/21/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var calendarList = [String]()
    var selectedCalendarTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarPicker.delegate = self
        self.calendarPicker.dataSource = self
    }
    
    @IBOutlet weak var ufcSwitch: UISwitch!
    
    
    @IBOutlet weak var bellatorSwitch: UISwitch!
    
    
    @IBOutlet weak var chooseCalendarButton: UIButton!
    
    @IBAction func chooseCalendarButtonPressed(_ sender: Any) {
        initializeEventStore(viewController: self)
    }
    
    
    @IBOutlet weak var addEventsToCalendarButton: UIButton!
    
    
    @IBAction func addEventsButtonPressed(_ sender: UIButton) {
        //Clear the status text
        statusText.text = ""
        if ufcSwitch.isOn {
            loadEventsFromNetAndAddToCalendar(calendarTitle: selectedCalendarTitle, viewController: self, eventType: "ufc")
        }
        if bellatorSwitch.isOn {
            loadEventsFromNetAndAddToCalendar(calendarTitle: selectedCalendarTitle, viewController: self, eventType: "bellator")
        }
        
    }
    
    
    @IBAction func removeEventsButtonPressed(_ sender: UIButton) {
        //Clear the status text
        statusText.text = ""
        if ufcSwitch.isOn {
            loadEventsFromNetAndRemoveFromCalendar(calendarTitle: selectedCalendarTitle, viewController: self, eventType: "ufc")
        }
        if bellatorSwitch.isOn {
            loadEventsFromNetAndRemoveFromCalendar(calendarTitle: selectedCalendarTitle, viewController: self, eventType: "bellator")
        }
        
    }
    
    
    @IBOutlet weak var statusText: UITextView!
    
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
        
        selectedCalendarTitle = calendarList[row]
        chooseCalendarButton.setTitle(calendarList[row], for: .normal)
        self.calendarPicker.isHidden = true
    }
    
    //Update calendar data to user's list of calendar's when the 'Select Calendar' button is pressed
    func updateCalendarData(calendarList: [String]){
        self.calendarList = calendarList
        self.calendarPicker.reloadAllComponents()
        self.calendarPicker.isHidden = false
    }
    
    //Updates the text of the status label.  The status label is a textView that shows the status of the addition/removal of events from the calendar
    func appendStatusLabelText(with value: String){
        statusText.text.append(value)
    }
    
    func showAlert(display message:String){
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
}



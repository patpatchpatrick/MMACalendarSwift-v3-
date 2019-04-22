//
//  ViewController.swift
//  MMACalendar
//
//  Created by Patrick Doyle on 4/21/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebpage()
    }
    
    
    @IBOutlet weak var ufcSwitch: UISwitch!
    
    @IBOutlet weak var bellatorSwitch: UISwitch!
    
   
    @IBAction func chooseCalendarButtonPressed(_ sender: Any) {
        initializeEventStore()
    }
    


}



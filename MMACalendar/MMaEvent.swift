//
//  MMAEvent.swift
//  MMACalendar
//
//  Created by Patrick Doyle on 4/21/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation

class MMAEvent: CustomStringConvertible {
    var description: String {return "Title: " + title + "Date: " + testDate + "Details: " + details}
    
    var title: String = ""
    var date: Date = Date(timeIntervalSince1970: 0)
    var testDate: String = ""
    var details: String = ""
    
    init(title: String) {
        self.title = title
    }
    
    func addDate(date: String?){
        self.testDate = date!
    }
    
    func addDetails(details: String?){
        self.details += "\n" + details!
    }
}

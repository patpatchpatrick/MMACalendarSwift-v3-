//
//  MMAEvent.swift
//  MMACalendar
//
//  Created by Patrick Doyle on 4/21/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation

class MMAEvent: CustomStringConvertible {
    var description: String {return "Title: " + title + "Details: " + details}
    
    var title: String = ""
    var date: Date = Date(timeIntervalSince1970: 0)
    var details: String = ""
    
    init(title: String) {
        self.title = title
    }
    
    func addDate(date: String?){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM-dd-yyyy'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let dateSplit: Array<Substring> = date!.split(separator: " ")
        let year = String(dateSplit[2])
        let month = String(dateSplit[0])
        let daySub = String(dateSplit[1])
        var day = daySub.prefix(upTo: daySub.firstIndex(of: ",")!)
        if day.count == 1 {
            day = "0" + day
        }
        
        var formattedDate = ""
        
        switch (month) {
        case "January":
            formattedDate.append("01-")
        case "February":
            formattedDate.append("02-")
        case "March":
            formattedDate.append("03-")
        case "April":
            formattedDate.append("04-")
        case "May":
            formattedDate.append("05-")
        case "June":
            formattedDate.append("06-")
        case "July":
            formattedDate.append("07-")
        case "August":
            formattedDate.append("08-")
        case "September":
            formattedDate.append("09-")
        case "October":
            formattedDate.append("10-")
        case "November":
            formattedDate.append("11-")
        case "December":
            formattedDate.append("12-")
        default:
            formattedDate.append("01-")
        }
        
        formattedDate.append(day + "-" + year + "T17:00:00-08:00")
        self.date = dateFormatter.date(from: formattedDate)!
        
    }
    
    func addDetails(details: String?){
        self.details += "\n" + details!
    }
}

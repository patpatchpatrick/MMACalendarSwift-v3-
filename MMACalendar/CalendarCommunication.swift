//
//  CalendarCommunication.swift
//  MMACalendar
//
//  Created by Patrick Doyle on 4/22/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation
import EventKit
import UIKit

func initializeEventStore(viewController: ViewController) {
    
    let eventStore = EKEventStore()
    switch EKEventStore.authorizationStatus(for: .event) {
    case .authorized:
        queryCalendars(store: eventStore, viewController: viewController)
    case .denied:
        print("Denied")
    case .notDetermined:
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                queryCalendars(store: eventStore, viewController: viewController)
            } else {
                // Do something else (show an alert)
            }
        })
    default:
        print("Default")
        
}
}

func queryCalendars(store: EKEventStore, viewController: ViewController){
    let calendars = store.calendars(for: .event)
    var calendarNames = [String]()
    for calendar in calendars {
        calendarNames.append(calendar.title)
    }
    viewController.updateCalendarData(calendarList: calendarNames)
    
 
}

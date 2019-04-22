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
import Dispatch

var eventStore: EKEventStore = EKEventStore()

func initializeEventStore(viewController: ViewController) {
    
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
    var calendarList = [String]()
    for calendar in calendars {
        calendarList.append(calendar.title)
    }
    
    
    //Updates to UI must take place on main thread
    DispatchQueue.main.async {
         viewController.updateCalendarData(calendarList: calendarList)
    }    
    
}

func addEventsToCalendar(mmaEvents: [MMAEvent], to calendarTitle: String, viewController: ViewController){
    let calendars = eventStore.calendars(for: .event)
    var statusString = "Events Added/Updated: "
    for calendar in calendars {
        if calendar.title == calendarTitle {
            for mmaEvent in mmaEvents {
                
                let startDate = mmaEvent.date
                let endDate = startDate.addingTimeInterval(3 * 60 * 60)
                
                let event = EKEvent(eventStore: eventStore)
                event.calendar = calendar
                
                event.title = mmaEvent.title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = mmaEvent.description
               
                
                
                
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                    let id = event.eventIdentifier ?? "NO ID"
                    let preferences = UserDefaults.standard
                    let currentLevelKey = mmaEvent.key
                    let currentLevel = preferences.set(id, forKey: currentLevelKey)
                    //  Save to disk
                    let didSave = preferences.synchronize()

                    statusString.append("\n" + event.title)
                }
                catch {
                    statusString.append("Error Saving Events to Calendar")
                    print("Error saving event in calendar")             }
            }
            
        }
    }
    
    //Updates to UI must take place on main thread
    DispatchQueue.main.async {
        viewController.updateStatusLabelText(to: statusString)
    }

}

func removeEventsFromCalendar(mmaEvents: [MMAEvent], to calendarTitle: String, viewController: ViewController){
    let calendars = eventStore.calendars(for: .event)
    var statusString = "Events Removed: "
    for calendar in calendars {
        if calendar.title == calendarTitle {
            for mmaEvent in mmaEvents {
                
                let key = mmaEvent.key
                
                do {
                    var eventID = ""
                    let preferences = UserDefaults.standard
                    if preferences.object(forKey: key) == nil {
                        print("Pref Key Missing for Event")
                    } else {
                        eventID = preferences.string(forKey: key)!
                    }
                    
                    print("EVENT ID" + eventID)
                    let event = eventStore.event(withIdentifier: eventID)
                    
                    if(event != nil){
                        try eventStore.remove(event!, span: .thisEvent)
                        statusString.append("\n" + event!.title)
                    }
                    
                    
                }
                catch {
                    statusString.append("Error Removiong Events from Calendar")
                    print("Error removing events from calendar")             }
            }
            
        }
    }
    
    //Updates to UI must take place on main thread
    DispatchQueue.main.async {
        viewController.updateStatusLabelText(to: statusString)
    }
    
}



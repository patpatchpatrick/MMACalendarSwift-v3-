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

//Class to control communication with device calendar

var eventStore: EKEventStore = EKEventStore()
var mainViewController: ViewController = ViewController()


func initializeEventStore(viewController: ViewController) {

    //Initialize the event store and request access to device calendar
    // if access is not currently granted
    mainViewController = viewController
    switch EKEventStore.authorizationStatus(for: .event) {
    case .authorized:
        queryCalendars(store: eventStore, viewController: viewController)
    case .denied:
        mainViewController.showAlert(display: "Calendar Access Denied.\nGo to App Settings and Enable Calendar Access.")
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
    
    //Query list of user's calendars in their phone and display them in the UIPicker
    //in the view controller
    
    let calendars = store.calendars(for: .event)
    var calendarList = [String]()
    for calendar in calendars {
        //Add calendar to UIPicker only if it is allowed to be modified
        if calendar.allowsContentModifications {
                calendarList.append(calendar.title)
        }
        
    }
    
    
    //Updates to UI must take place on main thread
    DispatchQueue.main.async {
         viewController.updateCalendarData(calendarList: calendarList)
    }    
    
}

func addOrUpdateEventsInCalendar(mmaEvents: [MMAEvent], to calendarTitle: String, viewController: ViewController){
    
    //Add or update events in the user's calendar
    //The current calendar selected by the user is passed in as input
    //This calendar is found in the eventStore and then a new MMA Event is updated
    //or added to this calendar depending on if the event already exists or not
    
    //User preferences are used to determine if an event already exists
    //If an event has already been added to the calendar, it will have a stored event ID preference
    
    let calendars = eventStore.calendars(for: .event)
    var statusString = "Events Added/Updated: "
    for calendar in calendars {
        if calendar.title == calendarTitle {
            for mmaEvent in mmaEvents {
                
                let key = mmaEvent.key
                var eventID = ""
                let preferences = UserDefaults.standard
                if preferences.object(forKey: key) == nil {
                    let status = addEventToCalendar(mmaEvent: mmaEvent, to: calendar)
                    statusString.append(status)
                } else {
                    eventID = preferences.string(forKey: key)!
                    let status = updateEventInCalendar(mmaEvent: mmaEvent, with: eventID, in: calendar)
                    statusString.append(status)
                }
                
            }
            
        }
    }
    
    statusString.append("\n\n")
    
    //Updates to UI must take place on main thread
    //Update the main UI to show the status
    //The status will either be a list of events added/updated successfully or an error message
    DispatchQueue.main.async {
        viewController.appendStatusLabelText(with: statusString)
    }

}

func addEventToCalendar(mmaEvent: MMAEvent, to calendar: EKCalendar) -> String{
    
    //Add an MMA Event to the user's calendar and return a String with the event title
    //If calendar throws error, return String indicating that event couldn't be added
    //After event is added to calendar, store a preference with the event ID to be used
    //for future event updates/removals
    
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
        _ = preferences.set(id, forKey: currentLevelKey)
        _ = preferences.synchronize()
        
        return "\n" + event.title
    }
    catch {
        return "Error Saving Events to Calendar"  }
}

func updateEventInCalendar(mmaEvent: MMAEvent, with id: String, in calendar: EKCalendar) -> String{
    
    //Update an MMA Event in the user's calendar and return a String with the event title
    //If calendar throws error, return String indicating that event couldn't be updated
    //If event can't be retrieved from the eventStore, then the event may have been previously removed
    //In this case, add the event instead of updating it
    
    let storeEvent = eventStore.event(withIdentifier: id)
    
    if storeEvent == nil {
        //If Store Event is nil, app may be attempting to update a previously removed event
        //In this case, add the event to the calendar instead of updating the event
        return addEventToCalendar(mmaEvent: mmaEvent, to: calendar)
    } else {
        let event = storeEvent!
        event.title = mmaEvent.title
        event.startDate = mmaEvent.date
        event.endDate = event.startDate.addingTimeInterval(3 * 60 * 60)
        event.notes = mmaEvent.description
        
        do {
            try eventStore.save(event, span: .thisEvent)
            return "\n" + event.title
            
        } catch {
            
            return "Error Updating Event"
        }
        
    }
    
}

func removeEventsFromCalendar(mmaEvents: [MMAEvent], to calendarTitle: String, viewController: ViewController){
    
    //Remove MMA Events from the user's calendar and return a String with the event titles
    //If calendar throws error, return String indicating that events couldn't be removed
  
    //Events are removed by getting the eventID stored in the User's prefs when the user originally added the event
    
    
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
                    statusString.append("Error Removing Events from Calendar")
                    print("Error removing events from calendar")             }
            }
            
        }
    }
    
    statusString.append("\n\n")
    
    //Updates to UI must take place on main thread
    //Update the main UI to show the status
    //The status will either be a list of events removed successfully or an error message
    DispatchQueue.main.async {
        viewController.appendStatusLabelText(with: statusString)
    }
    
}



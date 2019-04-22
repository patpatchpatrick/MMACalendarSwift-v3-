//
//  NetworkCommunication.swift
//  MMACalendar
//
//  Created by Patrick Doyle on 4/21/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import Foundation
import SwiftSoup
import Dispatch

func loadEventsFromNetAndAddToCalendar(calendarTitle: String, viewController: ViewController) {
    //Scrape web for MMA fight data asynchronously
    DispatchQueue.global(qos: .userInitiated).async {
        if let url = URL(string: "https://www.mmafighting.com/schedule") {
            do {
                let contents = try String(contentsOf: url)
                let html = contents
                let doc: Document = try SwiftSoup.parse(html)
                let dates: Array<Element> = try doc.select("h3").array()
                var dateIterator: IndexingIterator<Array<Element>> = dates.makeIterator()
                let events: Array<Element> = try doc.select("a").array()
                var mmaEvents = [MMAEvent] ()
                for event in events{
                    let title = try event.text()
                    let href = try event.attr("href")
                    if title != nil && href != nil && href.contains("fight-card") {
                        let mmaEvent = MMAEvent(title: title)
                        mmaEvents.append(mmaEvent)
                        let date = dateIterator.next()
                        if date != nil {
                            mmaEvent.addDate(date: try date?.text())
                        }
                    } else if title != nil && href != nil && href.contains("/fight/") {
                        mmaEvents[mmaEvents.count - 1].addDetails(details: title)
                    }
                }
                
                addEventsToCalendar(mmaEvents: mmaEvents, to: calendarTitle, viewController: viewController)
                
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
    }
    
}

func loadEventsFromNetAndRemoveFromCalendar(calendarTitle: String, viewController: ViewController) {
    //Scrape web for MMA fight data asynchronously
    DispatchQueue.global(qos: .userInitiated).async {
        if let url = URL(string: "https://www.mmafighting.com/schedule") {
            do {
                let contents = try String(contentsOf: url)
                let html = contents
                let doc: Document = try SwiftSoup.parse(html)
                let dates: Array<Element> = try doc.select("h3").array()
                var dateIterator: IndexingIterator<Array<Element>> = dates.makeIterator()
                let events: Array<Element> = try doc.select("a").array()
                var mmaEvents = [MMAEvent] ()
                for event in events{
                    let title = try event.text()
                    let href = try event.attr("href")
                    if title != nil && href != nil && href.contains("fight-card") {
                        let mmaEvent = MMAEvent(title: title)
                        mmaEvents.append(mmaEvent)
                        let date = dateIterator.next()
                        if date != nil {
                            mmaEvent.addDate(date: try date?.text())
                        }
                    } else if title != nil && href != nil && href.contains("/fight/") {
                        mmaEvents[mmaEvents.count - 1].addDetails(details: title)
                    }
                }
                
                removeEventsFromCalendar(mmaEvents: mmaEvents, to: calendarTitle, viewController: viewController)
                
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
    }
    
}

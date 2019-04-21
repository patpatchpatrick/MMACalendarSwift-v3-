//
//  ViewController.swift
//  MMACalendar
//
//  Created by Patrick Doyle on 4/21/19.
//  Copyright © 2019 Patrick Doyle. All rights reserved.
//

import UIKit
import SwiftSoup
import Dispatch

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebpage()
    }
    
    func loadWebpage() {
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: "https://www.mmafighting.com/schedule") {
                do {
                    let contents = try String(contentsOf: url)
                    let html = contents
                    let doc: Document = try SwiftSoup.parse(html)
                    let h3: Array<Element> = try doc.select("h3").array()
                    let fights: Array<Element> = try doc.select("a").array()
                    for fight in fights{
                        let title = try fight.text()
                        let href = try fight.attr("href")
                        if title != nil && href != nil && href.contains("fight-card") {
                            print("Event Name" + title)
                        
                        } else if title != nil && href != nil && href.contains("/fight/") {
                            print("Fight Data " + title)
                        }
                    }
                    for date in h3 {
                        print(date)
                    }
                } catch {
                    // contents could not be loaded
                }
            } else {
                // the URL was bad!
            }
        }
        
    }
  


}



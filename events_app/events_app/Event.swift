//
//  Event.swift
//  events_app
//
//  Created by Борис Малашенко on 20.02.2021.
//

import CoreData
import Foundation
import UIKit

@objc(Event)
extension Event {
    public override class func entity() -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: "Event", in: CoreDataHelper.instance.context)!
    }
    
    convenience init() {
        self.init(entity: Event.entity(), insertInto: CoreDataHelper.instance.context)
        self.id = Int32.random(in: 1..<Int32.max)
    }
    
    convenience init(title: String, date: Date, status: String = "", comment: String = "") {
        self.init()
        self.title = title
        self.date = date
        self.status = status
        self.comment = comment
    }
    
    @nonobjc
    convenience init(codingEvent: CodingEvent) {
        self.init()
        self.id = codingEvent.id
        self.title = codingEvent.title
        self.date = codingEvent.date
        self.status = codingEvent.status
        self.comment = codingEvent.comment
    }
}

class CodingEvent: Codable {
    let id: Int32
    let title: String
    let date: Date
    let status: String
    let comment: String
    
    init(id: Int32, title: String, date: Date, status: String = "", comment: String = "") {
        self.id = id
        self.title = title
        self.date = date
        self.status = status
        self.comment = comment
    }
    
    init(event: Event) {
        self.id = event.id
        self.title = event.title ?? ""
        self.date = event.date ?? Date()
        self.status = event.status ?? ""
        self.comment = event.comment ?? ""
    }
}

//
//  EventsViewModel.swift
//  events_app
//
//  Created by Борис Малашенко on 26.02.2021.
//

import SwiftUI
import Foundation

class EventsViewModel: ObservableObject {
    @Published var events: [Event] = []
    
    func addEvent(event: Event) {
        if (!events.isEmpty) {
            for i in 0...events.count - 1 {
                if (event.id == events[i].id) {
                    events[i] = event
                    return
                }
            }
        }
        
        events.append(event)
        
        events.sort(by: {$0.date! > $1.date!})
    }
    
    static func getNearestUncomplitedEvent() -> Event? {
        let date = Date()
        let events = getEvents()
        for event in events {
            if event.date! >= date && event.status != "completed" {
                return event
            }
        }
        return nil
    }
    
    static func setEvents(events: [Event]) {
        var codingEvents: [CodingEvent] = []
        for item in events {
            codingEvents.append(CodingEvent(event: item))
        }
        
        if let encoded = try? JSONEncoder().encode(codingEvents) {
            defaults.setValue(encoded, forKey: "Events")
        }
    }
    
    static func getEvents() -> [Event] {
        if let data = defaults.data(forKey: "Events"),
           let codingEvents = try? JSONDecoder().decode([CodingEvent].self, from: data) {
            
            var events: [Event] = []
            for item in codingEvents {
                let event = Event(codingEvent: item)
                events.append(event)
            }
            return events
        }
        return []
    }
}

extension Date {

  static func today() -> Date {
      return Date()
  }

  func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.next,
               weekday,
               considerToday: considerToday)
  }

  func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.previous,
               weekday,
               considerToday: considerToday)
  }

  func get(_ direction: SearchDirection,
           _ weekDay: Weekday,
           considerToday consider: Bool = false) -> Date {

    let dayName = weekDay.rawValue

    let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

    let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

    let calendar = Calendar(identifier: .gregorian)

    if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
      return self
    }

    var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
    nextDateComponent.weekday = searchWeekdayIndex

    let date = calendar.nextDate(after: self,
                                 matching: nextDateComponent,
                                 matchingPolicy: .nextTime,
                                 direction: direction.calendarSearchDirection)

    return date!
  }

}

// MARK: Helper methods
extension Date {
  func getWeekDaysInEnglish() -> [String] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_US_POSIX")
    return calendar.weekdaySymbols
  }

  enum Weekday: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
  }

  enum SearchDirection {
    case next
    case previous

    var calendarSearchDirection: Calendar.SearchDirection {
      switch self {
      case .next:
        return .forward
      case .previous:
        return .backward
      }
    }
  }
}

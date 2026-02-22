//
//  CalendarViewModel.swift
//  score-ios
//
//  Created by Duru Alayli on 2/11/26.
//

import EventKit
import Foundation
import UIKit

final class CalendarViewModel: ObservableObject{
    static let shared = CalendarViewModel()
    private let eventStore = EKEventStore()
    @Published var showAlert: Bool = false
    @Published var openSettings: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    private init() {}
    
    func requestAccessandAdd(event: Game) {
        eventStore.requestFullAccessToEvents{ [weak self] (granted, error) in
            guard let self = self else { return }
            if granted && error == nil {
                
                let title = "Cornell vs. \(event.opponent.name) \(event.sex) \(event.sport)"
                let existing = self.eventStore.predicateForEvents(
                    withStart: event.date,
                    end: event.date.addingTimeInterval(7200),
                    calendars: [self.eventStore.defaultCalendarForNewEvents].compactMap { $0 }
                )
                let existingEvents = self.eventStore.events(matching: existing)
                
                if existingEvents.contains(where: { $0.title == title && $0.startDate == event.date }) {
                    DispatchQueue.main.async {
                        self.alertTitle = "Game already added."
                        self.alertMessage = "This game is already added to your calendar."
                        self.showAlert = true
                    }
                    return
                }
                
                let calendarEvent = EKEvent(eventStore: self.eventStore)
                calendarEvent.title = title
                calendarEvent.startDate = event.date
                calendarEvent.endDate = event.date.addingTimeInterval(7200)
                calendarEvent.location = event.address
                calendarEvent.calendar = self.eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(calendarEvent, span: .thisEvent)
                    DispatchQueue.main.async {
                        if let url = URL(string: "calshow:\(event.date.timeIntervalSinceReferenceDate)") {
                            UIApplication.shared.open(url)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.alertTitle = "Game can't be added."
                        self.alertMessage = "There was an error adding Cornell vs. \(event.opponent.name) to your calendar."
                        self.showAlert = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.alertTitle = "Game can't be added."
                    self.alertMessage = "Calendar access denied. Please enable full calendar access in Settings."
                    self.showAlert = true
                    self.openSettings = true
                }
            }
        }
    }
}

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
    @Published var eachAlert: Alert?
    
    private init() {}
    
    struct Alert: Identifiable {
        let id = UUID()
        let alertTitle: String
        let alertMessage: String
        let openSettings: Bool
    }
    
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
                        self.showCalendarAlert (
                            alertTitle: "Game already added.",
                            alertMessage: "This game is already added to your calendar."
                        )
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
                        self.showCalendarAlert (
                            alertTitle: "Game can't be added.",
                            alertMessage: "There was an error adding Cornell vs. \(event.opponent.name) to your calendar."
                        )
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showCalendarAlert (
                        alertTitle: "Game can't be added.",
                        alertMessage: "Calendar access denied. Please enable full calendar access in Settings.",
                        openSettings: true
                    )
                }
            }
        }
    }
    
    private func showCalendarAlert(
        alertTitle: String,
        alertMessage: String,
        openSettings: Bool = false
    ) {
        self.eachAlert = Alert(
            alertTitle: alertTitle,
            alertMessage: alertMessage,
            openSettings: openSettings
        )
    }
}

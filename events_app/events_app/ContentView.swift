//
//  ContentView.swift
//  events_app
//
//  Created by Борис Малашенко on 20.02.2021.
//

import SwiftUI
import WidgetKit

let defaults = UserDefaults(suiteName: "group.events_app.WidgetShare")!

struct ContentView: View {
    @ObservedObject public var viewModel = EventsViewModel()
    
    //    @State var events: [Event] = []
    
    @State var filterStatus: String = "none"
    
    var body: some View {
        NavigationView {
            List {
                let events = viewModel.events
                if events.isEmpty {
                    Text("Add some events")
                } else {
                    Picker(filterStatus, selection: $filterStatus) {
                        ForEach(Event.getStatuses(), id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    ForEach(events, id: \.self) { event in
                        if (filterStatus == "none" || filterStatus == event.status) {
                            NavigationLink(destination: NewEventUIView(viewModel: viewModel, viewTitle: "Edit event", viewEvent: event)) {
                                HStack {
                                    Text(event.title!)
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("\(event.date!, formatter: ContentView.taskDateFormat)")
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteRaw)
                }
            }
            .navigationBarItems(
                trailing:
                    NavigationLink(destination: NewEventUIView(viewModel: viewModel, viewTitle: "New event", viewEvent: Event())) {
                        Image(systemName: "plus")
                    })
            .navigationTitle(Text("Events"))
            .onAppear(perform: {
                viewModel.events = EventsViewModel.getEvents()
            })
        }
    }
    
    private func deleteRaw(with indexSet: IndexSet) {
        indexSet.forEach { viewModel.events.remove(at: $0) }
        EventsViewModel.setEvents(events: viewModel.events)
    }
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

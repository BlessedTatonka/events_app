//
//  NewEventUIView.swift
//  events_app
//
//  Created by Борис Малашенко on 22.02.2021.
//

import SwiftUI

struct NewEventUIView: View {
    @ObservedObject var viewModel: EventsViewModel
    @State var viewTitle: String
    @State var viewEvent: Event
    
    @State var title: String
    @State var date: Date
    @State var status: String
    @State var repetition: String
    @State var comment: String
    
    init(viewModel: EventsViewModel, viewTitle: String, viewEvent: Event) {
        _viewModel = ObservedObject(initialValue: viewModel)
        _viewTitle = State(initialValue: viewTitle)
        _viewEvent = State(initialValue: viewEvent)
        _title = State(initialValue: viewEvent.title ?? "")
        _date = State(initialValue: viewEvent.date ?? Date())
        _status = State(initialValue: viewEvent.status ?? "none")
        _repetition = State(initialValue: viewEvent.repetition ?? "none")
        _comment = State(initialValue: viewEvent.comment ?? "")
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        List {
            HStack {
                Text("Title")
                    .bold()
                TextEditor(text: $title)
                    .multilineTextAlignment(.trailing)
            }
            HStack {
                DatePicker("Event date", selection: $date, displayedComponents: .date)
                    .font(Font.headline.bold())
            }
            HStack {
                Picker(status, selection: $status) {
                    ForEach(Event.getStatuses(), id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
//            HStack {
//                Picker("Repeat", selection: $repetition) {
//                    ForEach(Event.getRepetitionOptions(), id: \.self) {
//                        Text($0)
//                    }
//                }
//                .pickerStyle(MenuPickerStyle())
//            }
            VStack(alignment: .leading) {
                Text("Comment")
                    .bold()
                TextEditor(text: $comment)
                    .multilineTextAlignment(.trailing)
                    .frame(minHeight: 30)
            }
        }.environment(\.defaultMinListRowHeight, 50)
        .navigationBarTitle(Text(viewTitle))
        .navigationBarItems(trailing:
                                Button("Save") {
                                    save()
                                    presentationMode.wrappedValue.dismiss()
                                }
        )
        .onAppear(perform: {
            
        })
    }
    
    func save() {
        viewEvent.title = title
        viewEvent.date = date
        viewEvent.status = status
        viewEvent.comment = comment
        viewModel.addEvent(event: viewEvent)
        
        EventsViewModel.setEvents(events: viewModel.events)
    }
}

struct NewEventUIView_Previews: PreviewProvider {
    static var previews: some View {
        NewEventUIView(viewModel: EventsViewModel(), viewTitle: "Event", viewEvent: Event())
    }
}

extension Event {
    static func getStatuses() -> [String] {
        let statuses: [String] = ["none", "hot", "minor", "completed"]
        return statuses
    }
    
    static func getRepetitionOptions() -> [String] {
        let options: [String] = ["none", "Each week", "Each month", "Each year"]
        return options
    }
}

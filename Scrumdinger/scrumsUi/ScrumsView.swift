//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by HEMANTH on 29/11/22.
//

import SwiftUI

struct ScrumsView: View {
    
    @Binding var scrums :[DailyScrum]
    @State private var isPresentingNewScrumView = false
    @State private var newScrumData = DailyScrum.Data()
    
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void
    
    var body: some View {
        List {
            ForEach($scrums, id: \.id) { $scrum in
                NavigationLink(destination: DetailView(scrum: $scrum)) {
                    CardView(scrum: scrum)
                }
                .listRowBackground(scrum.theme.mainColor)
            }
            
        }
        .navigationTitle("Daily Scrums")
        .toolbar(){
            Button(action: {
                isPresentingNewScrumView = true
            }){
                Image(systemName: "plus")
            }
            
        }
        .sheet(isPresented: $isPresentingNewScrumView){
            NavigationView {
                DetailEditView(data: $newScrumData)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                newScrumData = DailyScrum.Data()
                                isPresentingNewScrumView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                let newScrum = DailyScrum(data: newScrumData)
                                scrums.append(newScrum)
                                isPresentingNewScrumView = false
                            }
                        }
                    }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}


struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        ScrumsView(scrums: .constant(DailyScrum.sampleData), saveAction: {})
    }
}

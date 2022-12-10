//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by HEMANTH on 28/11/22.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    
    @StateObject private var store = ScrumStore()
    @State private var errorWrapper: ErrorWrapper?
    
    var body: some Scene {
        WindowGroup {
            NavigationView(content: {
                ScrumsView(scrums: $store.scrums){
                    
                    Task{
                        do{
                            try   await   ScrumStore.save(scrums: store.scrums)
                        }catch{
                            //                            fatalError(error.localizedDescription)
                            errorWrapper = ErrorWrapper(error: error, guidance: "Try again later.")
                            
                        }
                    }
                    //                    ScrumStore.save(scrums: store.scrums) { result in
                    //                        if case .failure(let error) = result {
                    //                            fatalError(error.localizedDescription)
                    //                        }
                    //                    }
                    
                }
            })
            .task {
                do {
                    store.scrums = try await ScrumStore.load()
                } catch {
                    //                    fatalError("Error loading scrums.")
                    errorWrapper = ErrorWrapper(error: error, guidance: "Scrumdinger will load sample data and continue.")
                    
                }
                
            }.sheet(item: $errorWrapper, onDismiss: {
                store.scrums = DailyScrum.sampleData
            }){ wrapper in
                ErrorView(errorWrapper: wrapper)
            }
            //            .onAppear{
            //                ScrumStore.load { result in
            //                    switch result {
            //                    case .failure(let error):
            //                        fatalError(error.localizedDescription)
            //                    case .success(let scrums):
            //                        store.scrums = scrums
            //                    }
            //                }
            //            }
            
        }
    }
}

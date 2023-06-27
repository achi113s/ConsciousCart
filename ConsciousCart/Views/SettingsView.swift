//
//  SettingsView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/19/23.
//

import CoreData
import SwiftUI

struct SettingsView: View {
    var moc: NSManagedObjectContext
    
    @State private var settingsItems = ["Settings1", "Settings2"]
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack {
            Form {
                Section {
                    ForEach(settingsItems, id: \.self) { item in
                        Text(item)
                    }
                }
                
                Section("My Data") {
                    List {
                        Button("Delete My Data", role: .destructive) {
                            showingDeleteAlert = true
                        }
                        .alert("Delete My Data", isPresented: $showingDeleteAlert) {
                            Button("Cancel", role: .cancel) { }
                            Button("Delete", role: .destructive) {
                                CoreDataManager.deleteAllImpulses(moc: moc)
                            }
                        } message: {
                            Text("Are you sure you want to permanently delete all of your data? This action cannot be undone.")
                        }

                    }
                }
            }
        }
    }
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView(moc:)
//    }
//}

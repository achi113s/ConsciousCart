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
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack {
            Form {
                Section("My Data") {
                    List {
                        Button("Delete My Data", role: .destructive) {
                            showingDeleteAlert = true
                        }
                        .alert("Delete My Data", isPresented: $showingDeleteAlert) {
                            Button("Cancel", role: .cancel) { }
                            Button("Delete", role: .destructive) {
                                ImpulseDataManager.deleteAllImpulses(moc: moc)
                            }
                        } message: {
                            Text("Are you sure you want to permanently delete all of your Impulses? This action cannot be undone.")
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

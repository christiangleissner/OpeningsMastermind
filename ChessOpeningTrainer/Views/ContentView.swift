//
//  ContentView.swift
//  ChessOpeningTrainer
//
//  Created by Christian Gleißner on 19.04.23.
//

import SwiftUI
import ChessKit

struct ContentView: View {
    @StateObject var database = DataBase()
    @StateObject var settings = Settings()
    
    var body: some View {
        TabView {
            StartTrainView(database: database, settings: settings)
                .tabItem{
                    Label("Train", systemImage: "graduationcap")
                    
                }
            SettingsView(settings: settings)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

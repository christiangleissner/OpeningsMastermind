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
    @State private var showingSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(database.gametrees) { gameTree in
                        NavigationLink(destination: TrainView(gameTree: gameTree)) {
                            Text(gameTree.name)
                        }
                    }
                    .onDelete(perform: delete)
                }
                Button("Add Example GameTree", action: {
                    self.database.addExampleGameTree()
                })
            }
            .navigationTitle(Text("Opening Studies"))
            .toolbar {
                Button(action: {showingSheet = true}) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingSheet) {
                AddStudyView(database: database)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        database.removeGameTree(at: offsets)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

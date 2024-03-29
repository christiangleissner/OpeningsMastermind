//
//  PracticeCenterView.swift
//  OpeningsMastermind
//
//  Created by Christian Gleißner on 13.06.23.
//

import SwiftUI
import ChessKit

struct PracticeCenterView: View {
    @ObservedObject var database: DataBase
    @ObservedObject var settings: Settings
    
    @StateObject var vm: PracticeCenterViewModel
    @StateObject var vm_child: PracticeViewModel
    
    @State private var isShowingModal = false
//    @State private var selectedQueueItem: QueueItem?
    @State private var isShowingHelp = false
    
    init(database: DataBase, settings: Settings) {
        self._vm_child = StateObject(wrappedValue: PracticeViewModel(database: database, settings: settings))
        self._vm = StateObject(wrappedValue: PracticeCenterViewModel(database: database))
        self.database = database
        self.settings = settings
    }
    
    let size: CGFloat = 120
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    VStack {
                        if !vm.queueItems.isEmpty {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Up next")
                                        .font(.title2)
                                        .padding(.horizontal)
                                        .padding(.top)
                                    Spacer()
                                    Button {
                                        isShowingHelp = true
                                    } label: {
                                        Image(systemName: "questionmark.circle")
                                    }
                                    .popover(isPresented: $isShowingHelp, attachmentAnchor: .point(.leading), arrowEdge: .leading, content: {
                                        VStack(alignment: .leading, spacing: 20) {
                                            Text("This is your practice queue")
                                                .font(.headline)
                                            Text("You get suggestions for positions you have not played yet or to repeat to achieve the best training result")
                                        }
                                        .padding()
                                        .frame(width: 300)
                                        .truePopover()
                                    })
                                    .padding(.trailing)
                                }
                                
                                ScrollView(.horizontal) {
                                    LazyHStack {
                                        ForEach(vm.queueItems, id: \.gameNode.id) { queueItem in
                                            VStack() {
                                                ChessboardView(vm: DisplayBoardViewModel(annotation: (nil,nil), userColor: queueItem.gameTree.userColor, currentMoveColor: queueItem.gameNode.parents.first?.moveColor ?? .white, position: FenSerialization.default.deserialize(fen: queueItem.gameNode.fen)), settings: settings)
                                                    .rotationEffect(.degrees(queueItem.gameTree.userColor == .white ? 0 : 180))
                                                    .frame(height: min(max((geo.size.width-60)/2.5, 60), 150))
                                                Text(queueItem.gameTree.name)
                                                    .minimumScaleFactor(0.8)
                                                    .multilineTextAlignment(.center)
                                                Spacer()
                                            }
                                            .frame(width: min(max((geo.size.width-60)/2.5, 60), 150))
                                            .onTapGesture {
                                                vm_child.initializeQueueItem(queueItem: queueItem)
                                                self.isShowingModal = true
                                            }
                                        }
                                    }
                                }
                                
                                .padding(.horizontal, 10)
                                .padding(.bottom, 20)
                                .scrollIndicators(.hidden)
                            }
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .opacity(0.1)
                            }
                        }
                        VStack(alignment: .leading) {
                            if !database.gametrees.isEmpty {
                                Text("Practice specific opening")
                                
                                    .font(.title2)
                                    .padding(.horizontal)
                                    .padding(.top)
                            } else {
                                Text("First, add a custom opening or an example in the library")
                                    .font(.title2)
                                    .padding()
                            }
                            VStack(alignment: .leading) {
                                ForEach(database.gametrees, id: \.self) { tree in
                                    HStack() {
                                        Text(tree.name)
                                            .padding(.vertical, 10)
                                            .padding(.leading, 15)
                                        Spacer()
                                        Image(systemName: "arrow.right")
                                            .padding(.trailing, 15)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background {
                                        RoundedRectangle(cornerRadius: 5)
                                            .opacity(0.2)
                                    }
                                    .padding(.bottom, 5)
                                    .onTapGesture {
                                        self.tappedTree(tree: tree)
                                    }
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.bottom, 10)
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .opacity(0.1)
                        }
                    }
                    .scrollIndicators(.hidden)
                    .padding()
                }
                .navigationTitle("Practice")
                .onAppear() {
                    vm.getQueueItems()
                    vm_child.queueItems = vm.queueItems
                }
                .fullScreenCover(isPresented: $isShowingModal, onDismiss: didDismiss) {
                    PracticeView(database: database, settings: Settings(), vm: vm_child)
                }
            }
        }
    }
    
    func tappedTree(tree: GameTree) {
        self.vm_child.selectedGameTrees = Set([tree])
        self.vm_child.reset()
        self.isShowingModal = true
    }
    func didDismiss() {
        self.vm_child.reset()
        self.vm.getQueueItems()
    }
}

struct PracticeCenterView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeCenterView(database: DataBase(), settings: Settings())
    }
}

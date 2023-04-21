//
//  CreateStudyView.swift
//  ChessOpeningTrainer
//
//  Created by Christian Gleißner on 20.04.23.
//

import SwiftUI
import ChessKit

let startingFEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
let startingGamePosition = FenSerialization.default.deserialize(fen: startingFEN)

struct CreateStudyView: View {
    @State private var game = Game(position: startingGamePosition)
    @State private var text = "1. e4 (1. d3 d5) 1... f6"
    
    @State private var gameTree: GameNode?
    
    var body: some View {
        VStack {
            ChessBoardView(game: $game, currentNode: $gameTree)
            
//            HStack {
//                Button(action:{
//                    // Go back in time one move here temporarily
//                }) {
//                    Image(systemName: "arrow.left")
//                }
//                // Disabled if no moves yet played
//                .disabled(game.movesHistory.isEmpty)
//                .padding()
//                Button(action:{
//                    // Go forward in time one move here temporarily
//                }) {
//                    Image(systemName: "arrow.right")
//                }
//                // Has to be disabled if position is actual present position
//                .padding()
//            }
            // List with moves played to far; still has to be developed
            Text("Enter PGN below:")
            TextEditor(text: $text)
                .frame(height: 200)
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
            Button(action: {
                do {
                    try self.gameTree = decodePGN(pgnString: text)
                    print("Success")
                } catch {
                    print("Failure")
                }
            }) {
                Text("Enter")
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}

struct CreateStudyView_Previews: PreviewProvider {
    static var previews: some View {
        CreateStudyView()
    }
}

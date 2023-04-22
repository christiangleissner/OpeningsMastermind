//
//  MoveNode.swift
//  ChessOpeningTrainer
//
//  Created by Christian Gleißner on 20.04.23.
//

import Foundation
import ChessKit


class GameNode: Codable {
    let move: String
    
    var children: [GameNode] = []
    
    var moveNumber: Int = 0
    var moveColor: PieceColor = .black
    weak var parent: GameNode?
    
    init(moveString: String, parent: GameNode? = nil) {
        self.move = moveString
        
        if let parent = parent {
            self.moveNumber = parent.moveColor == .white ? parent.moveNumber : parent.moveNumber + 1
            self.moveColor = parent.moveColor == .white ? .black : .white
            self.parent = parent
        }
    }
    
    public func databaseContains(move: Move, in game: Game) -> (Bool, GameNode) {
        let decoder = SanSerialization.default
        let san = decoder.san(for: move, in: game)
        
        let isInData = self.children.contains(where: {$0.move == san})
        if isInData {
            return (true, self.children.first(where: {$0.move == san})!)
        } else {
            return (false, self)
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        children = try container.decode([GameNode].self, forKey: .children)
        move = try container.decode(String.self, forKey: .move)
        moveNumber = try container.decode(Int.self, forKey: .moveNumber)
        let moveColorString = try container.decode(String.self, forKey: .moveColor)
        if moveColorString == "white" {
            moveColor = .white
        } else {
            moveColor = .black
        }
        for child in children {
            child.parent = self
        }
      }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let moveColorString = moveColor == .white ? "white" : "black"
        
        try container.encode(children, forKey: .children)
        try container.encode(moveNumber, forKey: .moveNumber)
        try container.encode(moveColorString, forKey: .moveColor)
        try container.encode(move, forKey: .move)
    }
    
    func encodeRecursively(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let moveColorString = moveColor == .white ? "white" : "black"
        
        try container.encode(children, forKey: .children)
        try container.encode(moveNumber, forKey: .moveNumber)
        try container.encode(moveColorString, forKey: .moveColor)
        try container.encode(move, forKey: .move)
        
//        for child in children {
//            try child.encodeRecursively(to: encoder)
//        }
    }
    
    static func decodeRecursively(from decoder: Decoder) throws -> GameNode {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let children = try container.decode([GameNode].self, forKey: .children)
        let move = try container.decode(String.self, forKey: .move)
        let moveNumber = try container.decode(Int.self, forKey: .moveNumber)
        let moveColorString = try container.decode(String.self, forKey: .moveColor)
        
        let node = GameNode(moveString: move)
        node.children = children
        node.moveNumber = moveNumber
        node.moveColor = moveColorString == "white" ? .white : .black
        
        for i in 0..<children.count {
            node.children[i].parent = node
        }
        return node
    }
    
    enum CodingKeys: String, CodingKey {
            case move, children, moveNumber, moveColor, parent
        }
}

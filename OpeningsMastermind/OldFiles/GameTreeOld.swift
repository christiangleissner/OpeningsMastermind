//
//  GameTree.swift
//  ChessOpeningTrainer
//
//  Created by Christian Gleißner on 20.04.23.
//


import Foundation
import SwiftUI
import ChessKit

struct GameTreeOld: Codable, Hashable {
    let id: UUID
    static func == (lhs: GameTreeOld, rhs: GameTreeOld) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    let name: String
    let rootNode: GameNodeOld
    let userColor: PieceColor
    let pgnString: String
    let date: Date
    
    var lastPlayed: Date
    
    var progress: Double {
//        return Double.random(in: 0...0.8)
        return self.userColor == .white ? 1-self.rootNode.progress : 1-self.rootNode.children.first!.progress
    }
    
    init(with gametree: GameTreeOld) {
        self.name = gametree.name
        self.rootNode = gametree.rootNode
        self.userColor = gametree.userColor
        self.pgnString = gametree.pgnString
        
        self.date = Date()
        self.lastPlayed = Date(timeIntervalSince1970: 0)
        
        self.id = UUID()
    }
    
    init(name: String, rootNode: GameNodeOld, userColor: PieceColor, pgnString: String = "") {
        self.name = name
        self.rootNode = rootNode
        self.userColor = userColor
        self.pgnString = pgnString
        
        self.date = Date()
        self.lastPlayed = Date(timeIntervalSince1970: 0)
        
        self.id = UUID()
    }
//
//    init(name: String, pgnString: String, userColor: PieceColor) {
//        self.name = name
//        self.userColor = userColor
//
//        let rootNode = GameTree.decodePGN(pgnString: pgnString)
//
//        self.rootNode = rootNode
//        self.pgnString = pgnString
//
//        self.date = Date()
//        self.lastPlayed = Date(timeIntervalSince1970: 0)
//
//        self.id = UUID()
//    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.pgnString = try container.decode(String.self, forKey: .pgnString)
        self.date = try container.decodeIfPresent(Date.self, forKey: .date) ?? Date()
        self.lastPlayed = try container.decodeIfPresent(Date.self, forKey: .lastPlayed) ?? Date(timeIntervalSince1970: 0)
        
        let rootNode =  try GameNodeOld.decodeRecursively(from: decoder)
        self.rootNode = rootNode
        let userColorString = try container.decode(String.self, forKey: .userColor)
        self.userColor = userColorString=="white" ? .white : .black
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let userColorString = userColor == .white ? "white" : "black"
        
        try container.encode(name, forKey: .name)
        try container.encode(pgnString, forKey: .pgnString)
        try rootNode.encodeRecursively(to: encoder)
        try container.encode(userColorString, forKey: .userColor)
        
        try container.encode(date, forKey: .date)
        try container.encode(lastPlayed, forKey: .lastPlayed)
        try container.encode(id, forKey: .id)
    }
    
    enum CodingKeys: String, CodingKey {
            case name, rootNode, userColor, pgnString, date, lastPlayed, id
        }
}

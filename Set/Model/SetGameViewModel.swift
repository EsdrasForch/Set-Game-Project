//
//  SetGameViewModel.swift
//  Set
//
//  Created by Esdras Forch on 10/29/21.
//


import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published var model : SetGame!
    @Published var wasMatch: SetGame.State = .selectCard
    
    var cards: [SetGame.Card] {
        model.dealedCards
    }
    
    var cardsRemaining: Int {
        model.cardsRemainingInDeck
    }
    
    var statusText: String {
        switch wasMatch {
        case .selectCard:
            return "Choose your cards"
        case .noMatch:
            return "Not a set."
        case .match:
            return "That is a match!."
        case .noMoreCards:
            return "Well done! You win the game!."
        }
    }
    
    //We check if there is data inside of the physcial memory
    init() {
        guard let m = restoreSetGameFromUserDefaults() else {
            self.newGame()
            return
        }
        model = m
    }
    
    func choose(_ card: SetGame.Card) {
        wasMatch = model.select(card: card)
        switch wasMatch {
        case .match:
            storeSetGameInUserDefaults();
            break
        default:break
        }
    }
    
    func drawCard(_ number: Int = 1) {
        for _ in 0..<number {
            _ = model.addCard()
        }
        storeSetGameInUserDefaults()
    }
    
    func dealMoreCards() {
        drawCard(3)
    }
    
    func newGame() {
        model = SetGame()
        drawCard(12)
        storeSetGameInUserDefaults()
    }
    
    //Private function that will take care of our persistance and autosaving 
    private func storeSetGameInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(model), forKey: "gameModel")
    }
    //If there is data inside of the physical memory, it will decode it in the Set class
    private func restoreSetGameFromUserDefaults() -> SetGame? {
        if let jsonData = UserDefaults.standard.data(forKey: "gameModel"),
           let decodedModel = try? JSONDecoder().decode(SetGame.self,
                                                           from: jsonData) {
            return decodedModel
        }
        return nil
    }
    
}

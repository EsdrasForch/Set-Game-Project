//
//  SetGame.swift
//  Set
//
//  Created by Esdras Forch on 10/29/21.
//

import Foundation


//Set Game, Card and Deck structs codable in order to decode them and store the data
struct SetGame : Codable {

    private(set) var deck = Deck()
    private(set) var dealedCards: [Card] = []

    var cardsRemainingInDeck: Int {
        deck.remainingCardCount
    }

    mutating func addCard() -> Card? {
        guard let card = deck.drawCard()
        
        else {
            print("no more cards in deck")
            return nil
        }
        dealedCards.append(card)
        return card
    }

    mutating func select(card: Card) -> State {
        // Check if we had previously already 3 cards
        let selectedCards = dealedCards.filter { $0.isSelected }
        if selectedCards.count == 3 {

            // Replace matched cards with new ones
            for card in selectedCards {
                guard let index = dealedCards.firstIndex(matching: card)
                else {
                    print("\(card) suddenly disappeared!?")
                    continue
                }
                if card.isMatched {
                    dealedCards.remove(at: index)

                    if let newCard = deck.drawCard() {
                        dealedCards.insert(newCard, at: index)
                    }
                }
                else {
                    dealedCards[index].isSelected.toggle()
                }
            }

            if dealedCards.isEmpty {
                return .noMoreCards
            }
        }

        guard let index = dealedCards.firstIndex(matching: card) else {
            print("\(card) is no more part of the dealed cards")
            return .selectCard
        }

        dealedCards[index].isSelected.toggle()

        return checkMatch()
    }

    private mutating func checkMatch() -> State {

        let selectedItems = dealedCards.enumerated().filter { item -> Bool in
            item.element.isSelected
        }
        guard selectedItems.count == 3 else { return .selectCard }

        var features = [AnyHashable:Int]()
        for (_, card) in selectedItems {
            features[card.number.rawValue, default: 0]  += 1
            features[card.color.rawValue, default: 0]   += 1
            features[card.shading.rawValue, default: 0] += 1
            features[card.shape.rawValue, default: 0]   += 1
        }

        // there shouldn't be 2 of a kind in any feature
        let mismatchingFeatures = features.filter { $0.value == 2}.map { $0.key }
        let isMatch = mismatchingFeatures.isEmpty
        if isMatch {
            for (index, _) in selectedItems {
                dealedCards[index].isMatched = true
            }
        }

        return isMatch ? .match : .noMatch(mismatchingFeatures)
    }

    enum State {
        case selectCard
        case noMatch([AnyHashable])
        case match
        case noMoreCards
    }

    enum Number: Int, Codable, CaseIterable, Hashable {
        case one = 1,
             two,
             three
    }

    enum Color: String, Codable, CaseIterable, Hashable {
        case red =    "🟥",
             purple = "🟪",
             green =  "🟩"
    }

    enum Shading: String, Codable, CaseIterable, Hashable {
        case solid,
             stripped,
             outlined
    }

    enum Shape: String, Codable, CaseIterable, Hashable, CustomStringConvertible {
        case oval , squiggle, diamond

        var description: String {
            switch self {
                case .oval:
                    return "O"
                case .squiggle:
                    return "~"
                case .diamond:
                    return "◇"
            }
        }
    }

    struct Card: Identifiable, Equatable, Codable, CustomStringConvertible {
        var isSelected: Bool = false
        var isMatched: Bool = false

        var number: Number
        var color: Color
        var shape: Shape
        var shading: Shading
        var id = UUID()

        var description: String {
            "Card(\(String(repeating: shape.description, count: number.rawValue)) \(shading) \(color.rawValue))"
        }
        
        
        init(number:Number, color : Color, shape : Shape, shading : Shading) {
            self.number = number
            self.color = color
            self.shape = shape
            self.shading = shading
        }
    }

    struct Deck : Codable {
        private var cards: [Card] = []

        init() {
            for number in  Number.allCases {
                for color in Color.allCases {
                    for shape in Shape.allCases {
                        for shading in Shading.allCases {
                            cards.append(Card(number: number, color: color, shape: shape, shading: shading))
                        }
                    }
                }
            }
            cards.shuffle()
        }

        var remainingCardCount: Int {
            cards.count
        }

        mutating func drawCard() -> Card? {
            guard cards.count > 0 else {
                return nil
            }
            return cards.removeFirst()
        }
    }
}

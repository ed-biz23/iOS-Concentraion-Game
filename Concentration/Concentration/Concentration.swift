//
//  Concentration.swift
//  Concentration
//
//  Created by Edward Biswas on 9/5/18.
//  Copyright © 2018 Edward Biswas. All rights reserved.
//

import Foundation

struct Concentration {
    
    var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        foundIndex = nil
                    }
                }
            }
            return foundIndex
        }
        
        set(newValue) {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var flipCount = 0
    
    var score = 0
    
    private var previouslySeenCard = [Int]()
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index): chosen index not valid")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                previouslySeenCard.append(matchIndex)
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else if previouslySeenCard.contains(cards[matchIndex].identifier) {
                    score -= 1
                }
                cards[index].isFaceUp = true
            } else {
                // either 0 or 2 cards are face up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        flipCount += 1
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at leaast one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        // TODO: Shuffle the deck of cards in your homework
        var shuffled = [Card]()
        for _ in 0..<cards.count {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            shuffled.append(cards.remove(at: randomIndex))
        }
        cards = shuffled
    }
    
    func isAllMatched() -> Bool {
        for index in cards.indices {
            if !cards[index].isMatched {
                return false
            }
        }
        return true
    }
    
}

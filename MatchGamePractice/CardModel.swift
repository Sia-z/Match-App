//
//  CardModel.swift
//  MatchGamePractice
//
//  Created by Siyao on 2020/2/26.
//  Copyright © 2020 Siyao. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        // Declare an array to store numbers are already generated
        var generateNumbers = [Int]()
        
        // Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        // Randomly generate pairs of cards
        while generateNumbers.count < 8 { // To have 8 pairs
            
            let randomeNumber = arc4random_uniform(13) + 1
            
            if generateNumbers.contains(Int(randomeNumber)) == false{
                
                // Store the number into the generatNumber
                generateNumbers.append(Int(randomeNumber))
                
                // Create the first card
                let cardOne = Card()
                cardOne.imageName = "card\(randomeNumber)"
                
                generatedCardsArray.append(cardOne)
                
                // Create the second card
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomeNumber)"
                           
                generatedCardsArray.append(cardTwo)
                
            }
            
        }
        
        // TODO: Randomize the array
        
        for i in 0...generatedCardsArray.count-1 {
            
            // Find a random index to swap with
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            
            let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[randomNumber]
            generatedCardsArray[randomNumber] = temporaryStorage
        }
        
        
        // Return the array
        return generatedCardsArray
        
    }
}


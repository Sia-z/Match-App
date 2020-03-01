//
//  ViewController.swift
//  MatchGamePractice
//
//  Created by Siyao on 2020/2/26.
//  Copyright © 2020 Siyao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer:Timer?
    
    var milliseconds:Float = 40 * 1000 // 10 seconds
    
    var model = CardModel()
    
    var cardArray = [Card]()
    
    var firstCardFlippedIndex:IndexPath?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call the getCards method of the card model
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Creat timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        
        // Make sure timer still runs even the screen is being scrolled
        RunLoop.main.add(timer!, forMode: .common)
        
        SoundManager.playSound(.shuffle)
        
    }
    
    @objc func timerElapsed() {
        
        milliseconds -= 1
        
        // Convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        // Set label
        timerLabel.text = "Time Remaining: \(seconds)"
        
        // When the timer reaches zero
        if milliseconds <= 0 {
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            // Check if there are any cards unmatched
            checkGameEnded()
        }
        else{
            checkGameEnded()
        }
        
    }
    
    // MARK: UICollectionView Protocal Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a CardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Get the card will be displayed
        let card = cardArray[indexPath.row]
        
        // Set the card (image)
        cell.setCard(card)
        
        return cell
    }
    
    // User tapped on the cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check if there is time left
        if milliseconds <= 0 {
            return
        }
        
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false {
            // Flip the card
            cell.flip()
            
            // Play the flip sound
            SoundManager.playSound(.flip)
            
            card.isFlipped = true
            
            if firstCardFlippedIndex == nil {
                
                // This is the first card got flipped
                firstCardFlippedIndex = indexPath
            }
            else {
                
                // This is the second card got flipped
                checkForMatches(indexPath)
                
                // TODO: Perform the match logic
                
            }
        }
        
    }
    
    // MARK : Game Logic Methods
    
    func checkForMatches(_ secondCardFlippedIndex:IndexPath) {
        
        let cardOneCell = collectionView.cellForItem(at: firstCardFlippedIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondCardFlippedIndex) as? CardCollectionViewCell
        
        let cardOne = cardArray[firstCardFlippedIndex!.row]
        
        let cardTwo = cardArray[secondCardFlippedIndex.row]
        
        // Check if cards are matched
        if cardOne.imageName == cardTwo.imageName {
            
            // It is a match
            // Play sound
            SoundManager.playSound(.match)
            
            // Set the states
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Remove cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            
            
        }
        else {
            
            // It is not a match
            // Play sound
            SoundManager.playSound(.nomatch)
            
            // Set the states
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        // Tell the collection view to reload the cell for first cell if it is nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstCardFlippedIndex!])
        }
        
        // Reset the property that tracks the first card filpped
        firstCardFlippedIndex = nil
        
    }
    
    func checkGameEnded() {
        
        // Determine if there are any cards unmatched left
        var isWon = true
        var title = ""
        var message = ""
        
        for card in cardArray {
            
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        // If there is no unmatched cards left, check if there is time left
        if isWon == true && milliseconds > 0 {
            
            timer?.invalidate()
            
            title = "Congratulations!"
            message = "You've won"
            
        }
        else {
            
            // If there are unmatched cards, check if there is any time left
            if milliseconds > 0 {
                return
            }
            else
            {
                title = "Game Over"
                message = "You've lost"
            }
        }
        
        showAlert(title, message)
    }
    
    func showAlert(_ title:String, _ message:String) {
        
        // Show won/lose messaging
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }

}


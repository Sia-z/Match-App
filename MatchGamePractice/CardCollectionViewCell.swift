//
//  CardCollectionViewCell.swift
//  MatchGamePractice
//
//  Created by Siyao on 2020/2/26.
//  Copyright © 2020 Siyao. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    // Set the card to the card collection
    func setCard(_ card:Card) {
        
        // Keep track to the card gets passed in
        self.card = card
        
        // Make sure if the card is matched or not
        if card.isMatched == true {
            
            // If the card has been matched then make the image view be invisible
            frontImageView.alpha = 0
            backImageView.alpha = 0
            
            // Will not run the code after if it is matched
            return
        }
        else {
            
            // If the card has not been matched then make the image view be visible
            frontImageView.alpha = 1
            backImageView.alpha = 1
        }
        
        frontImageView.image = UIImage(named: card.imageName)
        
        // Because of the reused cell issue,
        // Determine if the card is a flipped up state or flipped down state
        if card.isFlipped == true {
            
            // Make sure the frontimageview is on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        else {
            
            // Make sure the backimageview is on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    // Flip the card
    func flip() {
        
        // The back will be hidden instead of being removed
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        
    }
    
    // Flip the card back
    func flipBack() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
        
    }
    
    func remove() {
        
        // Remove both image views being visible
        
        // Animate it
        UIView.animate(withDuration: 0.3, delay: 0.6, options: .curveEaseOut, animations: {
            
            self.frontImageView.alpha = 0
            
        }, completion: nil)
    }
    
    
}

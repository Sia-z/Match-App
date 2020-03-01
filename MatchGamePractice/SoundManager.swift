//
//  SoundManager.swift
//  MatchGamePractice
//
//  Created by Siyao on 2020/2/27.
//  Copyright © 2020 Siyao. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    static func playSound(_ effect:SoundEffect) {
        
        var soundFileName = ""
        
        // Determine which sound effect we want to play
        // And set filename to it
        switch effect {
            
        case .flip:
            soundFileName = "cardflip"
            
        case .match:
            soundFileName = "dingcorrect"
            
        case .shuffle:
            soundFileName = "shuffle"
            
        case .nomatch:
            soundFileName = "dingwrong"
            
        }
        
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: "wav")
        
        
        guard bundlePath != nil else {
            print("cannot find the sound file name \(soundFileName) in the bundle")
            return
        }
        
        // Create a URL object from this string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do {
        // Create audio player object
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            // Play the sound
            audioPlayer?.play()
        
        }
        catch {
            
            // Counld not create audio player object, log the error
            print("Could not create the audio player object for the sound file \(soundFileName)")
        }
        
    }
    
}

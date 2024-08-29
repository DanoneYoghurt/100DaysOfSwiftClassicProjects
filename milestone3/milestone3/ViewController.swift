//
//  ViewController.swift
//  milestone3
//
//  Created by Антон Баскаков on 28.08.2024.
//

import UIKit

class ViewController: UIViewController {
    
    var word = ""
    var allWords = [String]()
    var usedLetters = [String]()
    var promptWord = "?"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsUrl) {
                allWords = startWords.components(separatedBy: "\n")
            }
            
            if allWords.isEmpty {
                allWords = ["silkworm"]
            }
        }
        
        startGame()
    }
    
    
    func startGame() {
        word = allWords.randomElement()!
        
        var hiddenWord: String {
            var character = ""
            for letter in word {
                character += "?"
            }
            return character
        }
        
        title = hiddenWord
    }


}


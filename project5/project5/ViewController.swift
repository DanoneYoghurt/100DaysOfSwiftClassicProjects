//
//  ViewController.swift
//  project5
//
//  Created by Антон Баскаков on 13.08.2024.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()
    var currentWord = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(restartGame))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        

        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        do {
            guard let savedUsedWords = UserDefaults.standard.object(forKey: "usedWords") as? Data else {
                print("failed to find used words data in userdefautls")
                return
            }
            guard let savedCurrentWord = UserDefaults.standard.object(forKey: "currentWords") as? Data else {
                print("failed to find current word data in userdefautls")
                return
            }
            let decoder = JSONDecoder()
            
            self.usedWords = try decoder.decode([String].self, from: savedUsedWords)
            self.currentWord = try decoder.decode(String.self, from: savedCurrentWord)
            
        } catch {
            print("failed to load data")
        }
        
        startGame()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func startGame() {
        if currentWord.isEmpty {
            currentWord = allWords.randomElement() ?? "silkworm"
        }
        title = currentWord
        save()
        tableView.reloadData()
    }
    
    @objc func restartGame() {
        currentWord = allWords.randomElement() ?? "silkworm"
        title = currentWord
        usedWords.removeAll(keepingCapacity: true)
        save()
        tableView.reloadData()
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(lowerAnswer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    save()
                    
                    return
                } else {
                    showErrorMessage(errorTitle: "Word not recognised", errorMessage: "You can't just make them up, you know!")
                }
            } else {
                showErrorMessage(errorTitle: "Word used already", errorMessage: "Be more original!")
            }
        } else {
            guard let title = title?.lowercased() else { return }
            showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title)")
        }
        
        
        
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        if word.count > 2 && word != title {
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspeledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            return misspeledRange.location == NSNotFound
        } else {
            return false
        }
        
        
    }
    
    func save() {
        do {
            let savedUsedWords = try JSONEncoder().encode(usedWords)
            let savedCurrentWord = try JSONEncoder().encode(currentWord)
            UserDefaults.standard.setValue(savedUsedWords, forKey: "usedWords")
            UserDefaults.standard.setValue(savedCurrentWord, forKey: "currentWords")
        } catch {
            print("Failed to save")
        }
    }
}


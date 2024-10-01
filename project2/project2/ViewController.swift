//
//  ViewController.swift
//  project2
//
//  Created by Антон Баскаков on 05.08.2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var highScore = 0
    var correctAnswer = 0
    
    var questionNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        requestNotificationAuthorization()
        
        
        
        if let savedData = UserDefaults.standard.object(forKey: "highScore") as? Data {
            do {
                highScore = try JSONDecoder().decode(Int.self, from: savedData)
            } catch {
                print("failed to load")
            }
        }
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion(action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", image: UIImage(systemName: "gamecontroller"), target: self, action: #selector(navButtonTapped))
        
    }

    func askQuestion(action: UIAlertAction!) {
        countries.shuffle()
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        
        title = "\(countries[correctAnswer].uppercased()), Score: \(score)"
    }
    
    @objc func navButtonTapped() {
        let ac = UIAlertController(title: "Current score: \(score)", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .cancel))
        present(ac, animated: true)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10) {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            sender.transform = .identity
        }
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong, that's the flag of \(countries[sender.tag].uppercased())"
            if score > 0 {
                score -= 1
            }
        }
        questionNumber += 1
        
        if questionNumber < 10 {
            let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        } else {
            var message = ""
            
            if score < highScore {
                message = "Your final score is \(score)"
            } else {
                if score > highScore {
                    highScore = score
                    save()
                }
                message = "You beat your highscore! New highscore: \(highScore)"
                
            }
            
            let finalAc = UIAlertController(title: title, message: message, preferredStyle: .alert)
            finalAc.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
                self.score = 0
                self.questionNumber = 0
            }))
            present(finalAc, animated: true)
        }
        
    }
    
    func save() {
        if let savedData = try? JSONEncoder().encode(highScore) {
            UserDefaults.standard.setValue(savedData, forKey: "highScore")
        } else {
            print("Failed to save")
        }
    }
    
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Set a new high score!"
        content.body = "You have a new challenge waiting for you!"
        content.sound = .default
        
        var components = DateComponents()
        components.hour = 10
        components.minute = 00
        components.day = 7
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "highScoreNotification", content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                self.scheduleNotification()
            } else {
                print("Failed to request authorization")
            }
        }
    }
}


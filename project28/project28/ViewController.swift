//
//  ViewController.swift
//  project28
//
//  Created by Антон Баскаков on 21.10.2024.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!
    // Challenge 1: Add a Done button as a navigation bar item that causes the app to re-lock immediately rather than waiting for the user to quit. This should only be shown when the app is unlocked.
    var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        // Challenge 1
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
        doneButton.isHidden = true
        navigationItem.rightBarButtonItem = doneButton
        
        // Challenge 2
        KeychainWrapper.standard.set("hello", forKey: "password")
    }

    @IBAction func authentificateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        // Challenge 2: Create a password system for your app so that the Touch ID/Face ID fallback is more useful. You'll need to use an alert controller with a text field like we did in project 5, and I suggest you save the password in the keychain!
                        // enter password
                        ac.addAction(UIAlertAction(title: "Unlock with password", style: .default) { _ in
                            let ac = UIAlertController(title: "Enter password", message: nil, preferredStyle: .alert)
                            ac.addTextField()
                            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                            ac.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                                if let password = ac.textFields?.first?.text {
                                        // password is correct
                                        if password == KeychainWrapper.standard.string(forKey: "password") {
                                            self?.unlockSecretMessage()
                                        } else {
                                            // password is incorrect
                                            let ac = UIAlertController(title: "Incorrect password", message: "Please try again.", preferredStyle: .alert)
                                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                                            self?.present(ac, animated: true)
                                        }
                                }
                            })
                            self?.present(ac, animated: true)
                        })
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        secret.scrollIndicatorInsets = secret.contentInset

        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        
        // Challenge 1
        doneButton.isHidden = false
        
        title = "Secret Stuff!"
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        // Challenge 1
        doneButton.isHidden = true
        title = "Nothing to see here"
    }
    
}


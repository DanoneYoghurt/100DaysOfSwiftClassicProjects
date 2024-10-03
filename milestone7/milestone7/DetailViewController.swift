//
//  DetailViewController.swift
//  milestone7
//
//  Created by Антон Баскаков on 02.10.2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var textTextView: UITextView!
    
    var viewControllerDelegate: ViewController?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        titleTextView.becomeFirstResponder()
        titleTextView.textContainer.maximumNumberOfLines = 1
        
        if let index = index {
            titleTextView.text = viewControllerDelegate?.notes[index].title
            textTextView.text = viewControllerDelegate?.notes[index].text
        } else {
            let newNote = Note(title: "New note", text: "")
            
            titleTextView.text = newNote.title
            textTextView.text = newNote.text
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        save()
    }
    
    @objc func shareTapped() {
        guard let unwrappedTitle = titleTextView.text, let unwrappedText = textTextView.text else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [unwrappedTitle, unwrappedText], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func save() {
        if let index = index {
            
            viewControllerDelegate?.notes[index].title = titleTextView.text
            viewControllerDelegate?.notes[index].text = textTextView.text
        } else {
            let noteToSave = Note(title: titleTextView.text, text: textTextView.text)
            viewControllerDelegate?.notes.append(noteToSave)
        }
            viewControllerDelegate?.saveNotes()
            viewControllerDelegate?.tableView.reloadData()
        
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            textTextView.contentInset = .zero
        } else {
            textTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        textTextView.scrollIndicatorInsets = textTextView.contentInset

        let selectedRange = textTextView.selectedRange
        textTextView.scrollRangeToVisible(selectedRange)
    }
}

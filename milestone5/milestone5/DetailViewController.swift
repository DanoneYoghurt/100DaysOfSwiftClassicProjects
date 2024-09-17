//
//  DetailViewController.swift
//  milestone5
//
//  Created by Антон Баскаков on 17.09.2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    var country: Country?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var capitalLabel: UILabel!
    @IBOutlet var populationLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let country {
            title = country.name
            populationLabel.text = "Population: \(country.population)"
            capitalLabel.text = "Capital city: \(country.capital)"
            descriptionTextView.text = "\(country.countryDescription)"
            imageView.image = UIImage(named: country.name.lowercased())
            imageView.contentMode = .scaleAspectFill
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
}

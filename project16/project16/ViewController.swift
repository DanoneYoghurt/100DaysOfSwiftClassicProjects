//
//  ViewController.swift
//  project16
//
//  Created by Антон Баскаков on 18.09.2024.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Челлендж 2: Добавить кнопку переключения вида карты
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change map view", image: UIImage(systemName: "map"), target: self, action: #selector(showAlert))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    @objc func showAlert() {
        let ac = UIAlertController(title: "Change map style", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Satellite", style: .default) { _ in self.mapView.mapType = .satellite })
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default) { _ in self.mapView.mapType = .hybrid })
        ac.addAction(UIAlertAction(title: "Hybrid Flyover", style: .default) { _ in self.mapView.mapType = .hybridFlyover })
        ac.addAction(UIAlertAction(title: "Satellite Flyover", style: .default) { _ in self.mapView.mapType = .satelliteFlyover })
        ac.addAction(UIAlertAction(title: "Standard", style: .default) { _ in self.mapView.mapType = .standard })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    

    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
            
        }
        
        // Челлендж 1: Поиграться с цветом значка
        annotationView?.markerTintColor = .black
        annotationView?.glyphImage = UIImage(systemName: "pin.fill")
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Show info on Wikipedia", style: .default, handler: showWikipediaPage))
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
        
        // Челлендж 3: Показать станицу в википедии при нажатии на кнопку
        func showWikipediaPage(action: UIAlertAction) {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? DetailViewController {
                vc.placeName = capital.title
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}


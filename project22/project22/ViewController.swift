//
//  ViewController.swift
//  project22
//
//  Created by Антон Баскаков on 03.10.2024.
//

import CoreLocation
import UIKit

struct Beacon {
    let uuid: UUID
    let major: UInt16
    let minor: UInt16
    let identifier: String
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconReading: UILabel!
    
    var locationManager: CLLocationManager?
    
    // Challenge 1
    var alertShown = false
    
    let circle = UIView()
    
    override func loadView() {
        super.loadView()
        
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.backgroundColor = .white
        circle.layer.cornerRadius = 128
        view.insertSubview(circle, at: 0)
        
        NSLayoutConstraint.activate([
            circle.widthAnchor.constraint(equalToConstant: 256),
            circle.heightAnchor.constraint(equalToConstant: 256),

            circle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            circle.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        


        
        // Challenge 1
        if let savedFirstLocated = UserDefaults.standard.object(forKey: "firstLocated") as? Bool {
            alertShown = savedFirstLocated
            print("Loaded from userdefaults: \(savedFirstLocated)")
        } else {
            alertShown = false
            print("Failed to load from userdefaults")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    
                    // Challenge 2
                    startScanning(beacon: Beacon(uuid: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, major: 123, minor: 456, identifier: "First Beacon"))
                    startScanning(beacon: Beacon(uuid: UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!, major: 123, minor: 456, identifier: "Second Beacon"))
                }
            }
        }
    }
    
    // Challenge 2
    func startScanning(beacon: Beacon) {
        let beaconRegion = CLBeaconRegion(uuid: beacon.uuid, major: beacon.major, minor: beacon.minor, identifier: beacon.identifier)
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                
                self.circle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                
                self.circle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
                
                self.circle.transform = CGAffineTransform(scaleX: 1, y: 1)
            default:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                
                self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        // Challenge 2
        for beacon in beacons {
            // Challenge 1
            if !alertShown {
                let ac = UIAlertController(title: "Beacon located", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                ac.addAction(UIAlertAction(title: "Show again", style: .cancel, handler:  { action in
                    self.alertShown = false
                }))
                self.alertShown = true
                UserDefaults.standard.set(self.alertShown, forKey: "firstLocated")
                present(ac, animated: true)
            }
            beaconReading.text = beacon.timestamp.description
            update(distance: beacon.proximity)
        }
    }
}


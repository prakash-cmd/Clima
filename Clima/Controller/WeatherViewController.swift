//
//  ViewController.swift
//  Clima
//


import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityTextLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
     
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        searchTextField.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        
    }
    @IBAction func currentLocationButton(_ sender: UIButton) {
        locationManager.requestLocation()

    }
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            let url = weatherManager.urlForCity(city)
            weatherManager.getWeather(url: url) { icon, temp, city in
                DispatchQueue.main.async {
                    self.cityTextLabel.text = city
                    self.temperatureLabel.text = temp
                    self.conditionImageView.image = UIImage(systemName: icon)
                    
                }
            }
        }
        textField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locValue = locations.last {
            let url = weatherManager.urlForLatLong(locValue)
            weatherManager.getWeather(url: url) { icon, temp, city in
                DispatchQueue.main.async {
                    self.cityTextLabel.text = city
                    self.temperatureLabel.text = temp
                    self.conditionImageView.image = UIImage(systemName: icon)
                    
                }
            }
        }
    }
}



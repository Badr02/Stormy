//
//  ViewController.swift
//  Stormy
//
//  Created by Mohamed Adel on 07/11/2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, WeatherChangeDelegate, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var dayOne: UILabel!
    @IBOutlet weak var dayOneIcon: UIImageView!
    @IBOutlet weak var dayOneMin: UILabel!
    @IBOutlet weak var dayOneMax: UILabel!
    @IBOutlet weak var dayTwo: UILabel!
    @IBOutlet weak var dayTwoIcon: UIImageView!
    @IBOutlet weak var dayTwoMin: UILabel!
    @IBOutlet weak var dayTwoMax: UILabel!
    @IBOutlet weak var dayThree: UILabel!
    @IBOutlet weak var dayThreeIcon: UIImageView!
    @IBOutlet weak var dayThreeMin: UILabel!
    @IBOutlet weak var dayThreeMax: UILabel!
    @IBOutlet weak var loadingIcon: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    
    
    let stormyManager = StormyManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stormyManager.delegate = self
        stormyManager.checkInternet()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        rotateIcon()
        textField.delegate = self
        textField.layer.cornerRadius = 5
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !stormyManager.internetIsContected {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "NoInternet") as? NoInternetViewController {
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
            }
        } else {
            
            let locationCoordinates = CLLocation(latitude: 30.05785, longitude: 31.2497)
            stormyManager.urlByCoordinates(location: locationCoordinates)
        }
    }
    
    func didChangeWeather(weatherData: WeatherData) {
        UIView.animate(withDuration: 1) { [weak self] in
            self?.location.text = weatherData.locName
            self?.temp.text = "\(Int(weatherData.temp))°"
            self?.condition.text = weatherData.condition
            self?.weatherIcon.image = UIImage(systemName: weatherData.icon)
            self?.view.layoutIfNeeded()
        }
        
        UIView.transition(with: backgroundImage, duration: 3, options: .transitionCrossDissolve) { [weak self] in
            self?.backgroundImage.image = UIImage(named: weatherData.backgroundImage)
        }
        
        loadingIcon.isHidden = true
        loadingIcon.layer.removeAllAnimations()
                          
    }
    
    
    func didFiveDaysChange(threeDays: ThreeDaysWeatherData) {
        UIView.animate(withDuration: 1) { [weak self] in
            self?.dayOne.text = threeDays.days[0]
            self?.dayOneIcon.image = UIImage(systemName: threeDays.threeDaysIcon[0])
            self?.dayOneMin.text = "\(threeDays.dayOneWeather.min)°"
            self?.dayOneMax.text = "\(threeDays.dayOneWeather.max)°"
            
            self?.dayTwo.text = threeDays.days[1]
            self?.dayTwoIcon.image = UIImage(systemName: threeDays.threeDaysIcon[1])
            self?.dayTwoMin.text = "\(threeDays.dayTwoWeather.min)°"
            self?.dayTwoMax.text = "\(threeDays.dayTwoWeather.max)°"
            
            self?.dayThree.text = threeDays.days[2]
            self?.dayThreeIcon.image = UIImage(systemName: threeDays.threeDaysIcon[2])
            self?.dayThreeMin.text = "\(threeDays.dayThreeWeather.min)°"
            self?.dayThreeMax.text = "\(threeDays.dayThreeWeather.max)°"
            self?.view.layoutIfNeeded()
        }
            
    }
    
    @IBAction func locationWeather(_ sender: UIButton) {

        switch CLLocationManager().authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.requestLocation()
                loadingIcon.isHidden = false
                stormyManager.functionShouldStop = false
                rotateIcon()
            case .denied, .notDetermined, .restricted:
            let alert = UIAlertController(title: "Turn on your location setting in Stormy", message: "Your location is used to show local weather", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Go to setting", style: .default) { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert,animated: true)
            default:
                break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordiante = locations.last {
            stormyManager.urlByCoordinates(location: coordiante)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        loadingIcon.isHidden = true
        loadingIcon.layer.removeAllAnimations()

    }
    
    
    func rotateIcon() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.duration = 2
        animation.repeatCount = .infinity
        
        loadingIcon.layer.add(animation, forKey: nil)
        
    }

    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        textField.isUserInteractionEnabled = true
        textField.becomeFirstResponder()
        textField.backgroundColor = UIColor(white: 0, alpha: 0.2)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.text = ""
        textField.backgroundColor = UIColor(white: 0, alpha: 0)
        textField.isUserInteractionEnabled = false
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            let cityName = text.trimmingCharacters(in: .whitespacesAndNewlines)
            
            textField.text = ""
            textField.backgroundColor = UIColor(white: 0, alpha: 0)
            textField.isUserInteractionEnabled = false
            loadingIcon.isHidden = false
            rotateIcon()
            stormyManager.functionShouldStop = true
            stormyManager.urlByCityName(cityName: cityName)

        }
        
        return true
        
    }
    
    func invalidCityName() {
        loadingIcon.isHidden = true
        loadingIcon.layer.removeAllAnimations()
        let alert = UIAlertController(title: nil, message: "Invalid City Name", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)

    }
    
}


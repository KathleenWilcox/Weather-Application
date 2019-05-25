//
//  ViewController.swift
//  WeatherApplication
//
//  Created by Katie Wilcox on 5/25/19.
//  Copyright © 2019 Katie Wilcox. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet var background: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?zip=08901,us&units=imperial&appid=1dc61443af413f653a1022de8fafa78c") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in //creates url session, requests data
            
        if let data = data, error == nil {
            
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any]
                else { return }
             print(json)
            guard let weatherDetails = json["weather"] as? [[String : Any ]], let weatherMain = json["main"] as? [String: Any] else { return }
            let temp = Int(weatherMain["temp"] as? Double ?? 0)
            let description = (weatherDetails.first?["description"] as? String)?.capitalizingFirstLetter()
            DispatchQueue.main.async {
                self.setWeather(weather: weatherDetails.first?["main"] as? String, description: description, temp: temp)
            }
        }
        catch{
                print("Error retreiving data.")
            }
            
        }
    }
    task.resume()
}
    
    func setWeather(weather: String?, description: String?, temp: Int){
        weatherDescriptionLabel.text = description ?? "..."
        tempLabel.text = "\(temp)°"
        switch weather {
        case "Sunny":
            weatherImageView.image = UIImage(named: "sunny")
            background.backgroundColor = UIColor(red:0.97, green:0.78, blue: 0.35, alpha: 1.0)
        default:
            weatherImageView.image = UIImage(named: "cloudy")
            background.backgroundColor = UIColor(red: 0.42, green: 0.55, blue: 0.71, alpha: 1.0)
            }
        }
    }
extension String{
    func capitalizingFirstLetter() -> String{
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}


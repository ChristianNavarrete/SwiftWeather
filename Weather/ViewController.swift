//
//  ViewController.swift
//  Weather
//
//  Created by HoodsDream on 3/31/15.
//  Copyright (c) 2015 HoodsDream. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userCity: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var blurView: UIVisualEffectView!

    @IBAction func findWeather(sender: AnyObject) {
        
        var url = NSURL(string: "http://www.weather-forecast.com/locations/" + userCity.text.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        if url != nil {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                
                var urlError = false
                
                var weather = ""
                
                if error == nil {
                    
                    var urlContent = NSString(data: data, encoding: NSUTF8StringEncoding) as NSString!
                    
                    var urlContentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                    
                    if urlContentArray.count > 0 {
                        
                        var weatherArray = urlContentArray[1].componentsSeparatedByString("</span>")
                        
                        weather = weatherArray[0] as String
                        
                        weather = weather.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                        
                    } else {
                        
                        urlError = true
                        
                    }
                    
                    
                    
                } else {
                    
                    urlError = true
                    
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.userCity.resignFirstResponder()
                    
                    if urlError == true {
                        
                        self.showError()
                        
                    } else {
                        
                        self.resultLabel.text = weather
                        
                    }
                }
                
            })
            
            task.resume()
            
            
        } else {
            
            showError()
            
        }
        
        
    }
    
    func showError() {
        resultLabel.text = "Sorry could not find results for " + userCity.text + ". Please try again."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.userCity.delegate = self
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        self.blurView = UIVisualEffectView(effect:blurEffect)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}









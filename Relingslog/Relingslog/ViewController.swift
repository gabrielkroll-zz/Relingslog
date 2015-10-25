//
//  ViewController.swift
//  Relingslog
//
//  Created by Gabriel Kroll on 04/02/15.
//  Copyright (c) 2015 Gabriel Kroll. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK:  properties
    // for calculation
    var length : Double {
        var textFieldInsertLengthIntoDoubleValue = (textFieldInsertLength.text! as NSString).doubleValue
        return textFieldInsertLengthIntoDoubleValue
    }
    
    var time : Double {
        let timeStringIntoDoubleValue = (labelOutletForSecondsCount.text ?? "0" as NSString).doubleValue
        return timeStringIntoDoubleValue
    }
    
    var constant : Double {
        switch segmentedControlFtAndM.selectedSegmentIndex {
        case 0:
            switch segmentedControlKnMphKmh.selectedSegmentIndex {
            case 0:
                //println("00")
                return 0.592
            case 1:
                //println("01")
                return 0.682
            case 2:
                //println("02")
                return 1.079
            default:
                //println("default")
                return 0.0
            }
        case 1:
            switch segmentedControlKnMphKmh.selectedSegmentIndex {
            case 0:
                //println("10")
                return 1.944
            case 1:
                //println("11")
                return 2.237
            case 2:
                //println("12")
                return 3.6
            default:
                //println("default")
                return 0.0
            }
        default:
            //println("default")
            return 0.0
        }
    }
    
    var speed = 0.0
    
    // for the timer
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    
    // MARK:  UI elements
    // TEXTFIELD
    @IBOutlet var textFieldInsertLength: UITextField!
    
    // SEGMENTED CONTROLL
    @IBOutlet var segmentedControlFtAndM: UISegmentedControl!
    @IBAction func segmentedControlFtAndMButton(sender: AnyObject) {
        runTheLogic()
    }
    
    // SECONDS OUTLET
    @IBOutlet var labelOutletForSecondsCount: UILabel!
    
    // BUTTONS
    @IBAction func buttonForTimer(sender: AnyObject) {
        if !timer.valid {
            let aSelector : Selector = "timerUpdate"
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0/100.0, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
            
            self.textFieldInsertLength.resignFirstResponder()
            
            buttonForTimerOutlet.selected = true
            buttonForTimerOutlet.showsTouchWhenHighlighted = true
            buttonForTimerOutlet.setTitle("Stop", forState: .Selected)
            buttonForTimerOutlet.setTitleColor(UIColor.redColor(), forState: .Selected)
        } else {
            timer.invalidate()
            
            buttonForTimerOutlet.selected = false
            buttonForTimerOutlet.setTitle("Start", forState: .Normal)
            buttonForTimerOutlet.setTitleColor(UIColor.greenColor(), forState: .Normal)
            buttonForTimerOutlet.showsTouchWhenHighlighted = true
            
            runTheLogic()
        }
    }
    
    @IBOutlet var buttonForTimerOutlet: UIButton!
    
    // VELOCITY OUTLET
    @IBOutlet var labelOutletForVelocety: UILabel!
    
    // SEGMENTED CONTROLL
    @IBOutlet var segmentedControlKnMphKmh: UISegmentedControl!
    @IBAction func segmentedControlKnMphKmhButton(sender: AnyObject) {
        runTheLogic()
    }
    
    @IBAction func risignFirstResponderButton(sender: AnyObject) {
        // textField check
        labelOutletWithTextFieldCheck()
        // println("button pressed")
        textFieldInsertLength.resignFirstResponder()
    }
    
    // MARK:  functions
    
    func runTheLogic() {
        calculate()
        labelOutletWithTextFieldCheck()
        textFieldInsertLength.resignFirstResponder()
    }
    
    func labelOutletWithTextFieldCheck() {
        if textFieldInsertLength == "" {
            switch segmentedControlKnMphKmh.selectedSegmentIndex {
            case 0:
                //println("00")
                return labelOutletForVelocety.text = "0kn"
            case 1:
                //println("01")
                return labelOutletForVelocety.text = "0mph"
            case 2:
                //println("02")
                return labelOutletForVelocety.text = "0kmh"
            default:
                //println("default")
                return labelOutletForVelocety.text = "0kn"
            }
        } else if !(textFieldInsertLength == "") {
            switch segmentedControlKnMphKmh.selectedSegmentIndex {
            case 0:
                //println("00")
                return labelOutletForVelocety.text = "\(speed)kn"
            case 1:
                //println("01")
                return labelOutletForVelocety.text = "\(speed)mph"
            case 2:
                //println("02")
                return labelOutletForVelocety.text = "\(speed)kmh"
            default:
                //println("default")
                return labelOutletForVelocety.text = "\(speed)kn"
            }
        }
    }
    
    func calculate() -> Double {
        speed = length * constant / time
        return speed
    }
    
    func timerUpdate() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        // Finde the difference between current time and start time.
        var elapsedTime : NSTimeInterval = currentTime - startTime
        
        // Calculate the minutes in elapsed time.
        //let minutes = UInt8(elapsedTime / 60.0)
        //elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        // Calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        //let stringMinutes = minutes > 9 ? String(minutes):"0" + String(minutes)
        let stringSeconds = seconds // > 9 ? String(seconds):"0" + String(seconds)
        let stringFraction = fraction > 9 ? String(fraction):"0" + String(fraction)
        
        // Concatenate seconds and milliseconds as assign it to the UILabel
        labelOutletForSecondsCount.text = "\(stringSeconds),\(stringFraction)"
    }
    
    // MARK:  apple funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        buttonForTimerOutlet.setTitleColor(UIColor.greenColor(), forState: .Normal)
        labelOutletForSecondsCount.text = "0,00"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
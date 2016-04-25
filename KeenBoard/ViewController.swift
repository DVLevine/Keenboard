//
//  ViewController.swift
//  KeenBoard
//
//  Created by Daniel Visan Levine on 4/24/16.
//  Copyright © 2016 D-Line. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation
import JPSVolumeButtonHandler

class ViewController: UIViewController {

    
    // variable to keep track of starting point
    private var gestureStartPoint:CGPoint!
    private var pressHeld:Bool!
    private var volumeButtonHandler: JPSVolumeButtonHandler?
    
    // variable to keep track of the angle
    // variable to keep track of secondary gestures
    
    
    // left hand does level for letters
    
    
    // global variable for point start y
    
    // when specific angle registered, create vibration with strength proportional to depth
    
    //
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //For volume buttons
        let block =
        { print("Volume Up Press");
        self.changeColor(UIColor.whiteColor());
        };
        let lowBlock = {
            self.changeColor(UIColor.blackColor());
            print("Volume Down Press") };
        
        volumeButtonHandler = JPSVolumeButtonHandler(upBlock: block, downBlock: lowBlock)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // contact begins
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first;
        gestureStartPoint = touch!.locationInView(self.view)
        //print(gestureStartPoint);
        //gestureStartPoint.x = gestureStartPoint.x - 100;
        print("Touched");
        //print(gestureStartPoint);
        AudioServicesPlaySystemSound(1209)
    }
    
    
    // swirl motion continues
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let currentPosition = touch?.locationInView(self.view)
        
        //compute difference from start point
        let deltaX = Float(currentPosition!.x - gestureStartPoint.x);
        let deltaY = -Float(currentPosition!.y - gestureStartPoint.y);
        
        let angle = radiansToDegrees(genAngle(deltaX, deltaY: deltaY));
        
        print(angle);
        
        
        
        if (angle > 0 && angle < 30){
            AudioServicesPlaySystemSound(1209)
            changeColor(UIColor.redColor());
        }else if (angle > 30 && angle < 60){
            AudioServicesPlaySystemSound(1208)
            changeColor(UIColor.greenColor());
        }else if (angle > 60 && angle < 90){
            AudioServicesPlaySystemSound(1207)
            changeColor(UIColor.blueColor());
        }else if (angle > 90 && angle < 120){
            AudioServicesPlaySystemSound(1206)
            changeColor(UIColor.cyanColor());
        }else if (angle > 120 && angle < 150){
            AudioServicesPlaySystemSound(1205)
            changeColor(UIColor.yellowColor());
        }else if (angle > 150 && angle < 180){
            AudioServicesPlaySystemSound(1204)
            changeColor(UIColor.magentaColor());
        }else if (angle > 180 && angle < 210){
            AudioServicesPlaySystemSound(1203)
            changeColor(UIColor.orangeColor());
        }else if (angle > 220 && angle < 250){
            AudioServicesPlaySystemSound(1202)
            changeColor(UIColor.purpleColor());
        }else if (angle > 250 && angle < 280){
            AudioServicesPlaySystemSound(1201)
            changeColor(UIColor.brownColor());
        }else if (angle > 280 && angle < 310){
            AudioServicesPlaySystemSound(1200)
            changeColor(UIColor.lightGrayColor());
        }else if (angle > 310 && angle < 340){
            //AudioServicesPlaySystemSound(1200)
        }
        else{
            //AudioServicesPlaySystemSound(1204)
            //sleep(1)
        }//from difference compute angle
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("Touches Ended");
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        //UIDevice.currentDevice()._tapticEngine().actuateFeedback(1001)
    }
    
    
    // function for angle
    func genAngle(deltaX: Float, deltaY: Float) -> Float{
        
        let hyp = sqrtf(pow(deltaX,2.0)+pow(deltaY,2));
        
        //return atan(deltaY/deltaX);
        //return atan2(deltaY, deltaX);
        print("Delta X: " + (NSString(format: "%.2f",deltaX) as String));
        print("Delta Y: " + (NSString(format: "%.2f",deltaY) as String));
        
        
        var angle = acos(deltaY/hyp);
        
        if !(fabsf(deltaY) > 50 && fabsf(deltaX) > 50){
            angle = 0.0;
        }
        
        return acos(deltaY/hyp);
    }
    
    // functions for radian/degree conversion
    
    func degreesToRadians (value: Float) -> Float {
        return value * Float(M_PI/2) / 180.0
    }
    
    func radiansToDegrees (value: Float) -> Float {
        return value * 180.0 / Float(M_PI/2)
    }
    
    func changeColor(color: UIColor) {
        self.view.backgroundColor = color
    }
    
    // functions for using the volume buttons
    
    
    
    
    /*
    func listenVolumeButton(){
        let audioSession = AVAudioSession.sharedInstance();
        
        do{
        try audioSession.setActive(true);
        } catch{
            print(error);
        }
            
        //audioSession.setActive(true);
        audioSession.addObserver(self, forKeyPath: "outputVolume",
                                 options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject,
                                         change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "outputVolume"{
            print("got in here")
        }
    }*/
    
    
    
    // Exception handler code
    func checkaudioValid() throws -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setActive(true)
        
        if (audioSession.inputAvailable) {
            return true
        }
        return false
    }
    
    
   


}


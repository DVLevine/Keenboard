//
//  KeyboardViewController.swift
//  Lockpick
//
//  Created by Daniel Visan Levine on 4/25/16.
//  Copyright © 2016 D-Line. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation
import JPSVolumeButtonHandler

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!

    //custom keyboard
    var lockpickView: UIView!
    
    private var gestureStartPoint:CGPoint!
    private var pressHeld:Bool!
    private var volumeButtonHandler: JPSVolumeButtonHandler?
    
    // denotes if we are pressed
    private var pressToggle:Bool!
    
    // denotes if resting on a particular key (so don't repeat sounds)
    private var onKey:Bool!
    private var lastKey:Int!
    
    // variables for T9
    private var angle:Float!
    private var toggleNum:Int!
    private var toggleType:Int!
    
    
    //swath for backspace and space (not implemented presently)
    private var backspaceX: Float!
    private var spaceX: Float!
    
    // is caps on?
    private var caps: Bool!
    
    
    // audio player for custom sounds
    var audioPlayer:AVAudioPlayer!
    
    let t9Mapping: [Int:Array<String>] = [
        1 : [" ", ".", ",","?"],
        2 : ["A","B","C"],
        3 : ["D","E","F"],
        4 : ["G","H","I"],
        5 : ["J","K","L"],
        6 : ["M","N","O"],
        7 : ["P","Q","R","S"],
        8 : ["T","U","V"],
        9 : ["W","X","Y","Z"],
        10 : ["caps","no caps"],
        11 : ["space"],
        12 : ["delete"],
    ]
    
    // toggle Num for index of array stored in dictionary. Mods by the length of the array
    // execute by lower volume button
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInterface();
    }
    
    
    // loading nib
    func loadInterface() {
        //initializing
        pressToggle = false;
        toggleNum = 1;
        toggleType = 1;
        onKey = false;
        lastKey = 20; // impossible value
        caps = false; // capslock defaultly off
        
        // Setup Volume Button Controls
        let block =
            {print("Volume Up Press");
                if ((self.pressToggle) == true){
                    self.toggleType! = (self.toggleType + 1) % (((self.t9Mapping[self.toggleNum!]?.count)!+1));
                    if (self.toggleType == 0){
                        self.toggleType = 1;
                    }
                    
                    self.nextKeyboardButton.setTitle(NSLocalizedString(String(self.toggleType) + " | " + String(self.toggleNum) + " lst key: " + String(self.lastKey) + String(self.onKey), comment: "numa"), forState: .Normal);
                }
                self.changeColor((self.view.backgroundColor?.colorWithAlphaComponent(0.5))!);
                self.changeColor((self.view.backgroundColor?.colorWithAlphaComponent(1.0))!);

                    //UIColor.whiteColor());
                }
        let lowBlock = {
                // Enters text string from dictionary
                // only if finger is pressed against screen
            if ((self.pressToggle) == true){
                self.performEntry()
            }
               // self.changeColor(UIColor.blackColor());
                self.changeColor((self.view.backgroundColor?.colorWithAlphaComponent(0.5))!);
                self.changeColor((self.view.backgroundColor?.colorWithAlphaComponent(1.0))!);
            print("Volume Down Press");
        };
        
        volumeButtonHandler = JPSVolumeButtonHandler(upBlock: block, downBlock: lowBlock)
        print("GO");
        
        
        // Loads required keyboard buttons
        addNextKeyboardButton();
        
        // setup delete on leftmostside and space on rightmost
        let bounds = UIScreen.mainScreen().bounds;
        let width = bounds.size.width
        //let height = bounds.size.height
        
        backspaceX = Float(width/7);
        spaceX = Float(width - width/7);
        
        
        
        
    }
    
    // function for new switching between keyboards
    func addNextKeyboardButton() {
        self.nextKeyboardButton = UIButton(type: .System)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
        self.nextKeyboardButton.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
        
        
        self.view.backgroundColor = UIColor.brownColor();
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }
    
    
    // TOUCHES
    // contact begins
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first;
        gestureStartPoint = touch!.locationInView(self.view)
        pressToggle = true;
        
    }
    
    // swirl motion continues
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let currentPosition = touch?.locationInView(self.view)
        
        //compute difference from start point
        let deltaX = Float(currentPosition!.x - gestureStartPoint.x);
        let deltaY = -Float(currentPosition!.y - gestureStartPoint.y);
        
        angle = radiansToDegrees(genAngle(deltaX, deltaY: deltaY));
        
        print(angle);
        
        if (angle > 0 && angle < 30){
            changeColor(UIColor(red: 84/255, green: 48/255, blue: 5/255, alpha: 1));
            toggleNum = 1;
            
            if (!determineOnKey(lastKey)){
                //AudioServicesPlaySystemSound(1209)
                playSound("Tone1");
            }
            lastKey = 1;
            
        }else if (angle > 30 && angle < 60){
            changeColor(UIColor(red: 140/255, green: 81/255, blue: 10/255, alpha: 1));
            toggleNum = 2;
            
            if (!determineOnKey(lastKey)){
                //AudioServicesPlaySystemSound(1208)
                playSound("Tone2");
            }
            lastKey = 2;
            
        }else if (angle > 60 && angle < 90){
            changeColor(UIColor(red: 191/255, green: 129/255, blue: 45/255, alpha: 1));
            toggleNum = 3;
            
            if (!determineOnKey(lastKey)){
                //AudioServicesPlaySystemSound(1207)
                playSound("Tone4");
            }
            lastKey = 3;
            
        }else if (angle > 90 && angle < 120){
            changeColor(UIColor(red: 223/255, green: 194/255, blue: 125/255, alpha: 1));
            toggleNum = 4;
            
            if (!determineOnKey(lastKey)){
                //AudioServicesPlaySystemSound(1206)
                playSound("Tone5");
            }
            
            lastKey = 4;
        }else if (angle > 120 && angle < 150){
            changeColor(UIColor(red: 246/255, green: 232/255, blue: 195/255, alpha: 1));
            toggleNum = 5;
            
            if (!determineOnKey(lastKey)){
                //AudioServicesPlaySystemSound(1205)
                playSound("Tone6");
            }
            
            lastKey = 5;
        }else if (angle > 150 && angle < 180){
            changeColor(UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1));
            toggleNum = 6;
            
            if (!determineOnKey(lastKey)){
                //AudioServicesPlaySystemSound(1204)
                playSound("Tone7");
            }

            lastKey = 6;
        }else if (angle > 180 && angle < 210){
            changeColor(UIColor(red: 199/255, green: 234/255, blue: 229/255, alpha: 1));
            toggleNum = 7;
            
            if (!determineOnKey(lastKey)){
                //AudioServicesPlaySystemSound(1203)
                playSound("Tone8");
            }
            lastKey = 7;
        }else if (angle > 220 && angle < 250){
            changeColor(UIColor(red: 128/255, green: 205/255, blue: 193/255, alpha: 1));
            toggleNum = 8;
            
            if (!determineOnKey(lastKey)){
                //AudioServicesPlaySystemSound(1202)
                playSound("Tone9");
            }
            lastKey = 8;
        }else if (angle > 250 && angle < 280){
            changeColor(UIColor(red: 53/255, green: 151/255, blue: 143/255, alpha: 1));
            toggleNum = 9;
            
            if (!determineOnKey(lastKey)){
                //AudioServicesPlaySystemSound(1201)
                playSound("Tone10");
            }
            lastKey = 9;
        }else if (angle > 280 && angle < 310){
            changeColor(UIColor(red: 1/255, green: 102/255, blue: 94/255, alpha: 1));
            toggleNum = 10;
            
            if (!determineOnKey(lastKey)){
                //AudioServicesPlaySystemSound(1200)
                playSound("Tone11");
            }
            lastKey = 10;
        }else if (angle > 310 && angle < 340){
            changeColor(UIColor(red: 0/255, green: 60/255, blue: 48/255, alpha: 1));
            toggleNum = 11;
            
            if (!determineOnKey(lastKey)){
                //AudioServicesPlaySystemSound(1200)
                playSound("Tone12");
            }
            lastKey = 11;                   }
        else{
            // for delete
            toggleNum = 12;
            
            if (!determineOnKey(lastKey)){
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            lastKey = 12;
            
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("Touches Ended");
        //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        pressToggle = false;
    }
    
    
    // function for angle
    func genAngle(deltaX: Float, deltaY: Float) -> Float{
        
        let hyp = sqrtf(pow(deltaX,2.0)+pow(deltaY,2));
        
        //return atan(deltaY/deltaX);
        //return atan2(deltaY, deltaX);
        print("Delta X: " + (NSString(format: "%.2f",deltaX) as String));
        print("Delta Y: " + (NSString(format: "%.2f",deltaY) as String));
        
        angle = acos(deltaY/hyp);
        
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

    
    // Text entry behavior
    
    func performEntry(){
        let proxy = textDocumentProxy as UITextDocumentProxy
        
        let input = t9Mapping[toggleNum!]![toggleType!-1]
        
        if (input == "delete"){
            proxy.deleteBackward()
        }else if (input == "caps"){
            caps = true;
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }else if (input == "no caps"){
            caps = false;
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }else if (input == "space"){
            proxy.insertText(" ");
        }else{
            
            if (caps==true){
                proxy.insertText(input);
            }else{
                proxy.insertText(input.lowercaseString);
            }
            
        }
    }
    
    
    // test with dot 
    func didTapDot() {
        let proxy = textDocumentProxy as UITextDocumentProxy
        
        proxy.insertText(".")
    }
    
    func playSound(tone:String){
        let audioFilePath = NSBundle.mainBundle().pathForResource(tone, ofType: "caf")
        
        if audioFilePath != nil {
            
            let audioFileUrl = NSURL.fileURLWithPath(audioFilePath!)
            
            do{
            try audioPlayer = AVAudioPlayer(contentsOfURL: audioFileUrl)
            }
            catch{
                print("can't play file");
            }
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
        } else {
            print("cannot find file");
        }

        
    }
    
    func determineOnKey(lastRead:Int) -> Bool{
        let nowRead = self.toggleNum;
        
        if (lastRead == nowRead){
            onKey = true;
        }else{
            onKey = false;
            // reset t9 type toggle
            toggleType = 1;
        }
        return onKey
    }


    
    
    

}

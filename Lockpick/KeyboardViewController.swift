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
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // Programmatic instead of using xib
        //addNextKeyboardButton()
        loadInterface();
        
        //let viewRect = CGRectMake(10, 10, 100, 100);
        //let myView = UIView(frame: viewRect);
        //myView.backgroundColor = UIColor.blueColor();
        
        //view.addSubview(myView);
        
        //loadInterface()
        
        //Perform custom UI setup here
        /*
        */
    }
    
    
    // loading nib
    func loadInterface() {
        
        // Setup Volume Button Controls
        let block =
            {print("Volume Up Press");
                self.view.backgroundColor = UIColor.cyanColor();
                //self.changeColor(UIColor.whiteColor());}
                }
        let lowBlock = {
            //self.changeColor(UIColor.blackColor());
            print("Volume Down Press")
            self.view.backgroundColor = UIColor.blackColor();
        };
        
        volumeButtonHandler = JPSVolumeButtonHandler(upBlock: block, downBlock: lowBlock)
        print("GO");
        
        
        // Loads required keyboard buttons
        addNextKeyboardButton();
        
        // Loads special behavior
        
        
        
        
        
        /* load the nib file
        let lockpickNib = UINib(nibName: "Lockpick", bundle: nil)
        // instantiate the view
        
        lockpickView = lockpickNib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        //lockpickView = lockpickNib.instantiateWithOwner(self, options: nil)[0] as UIView
        
        // add the interface to the main view
        view.addSubview(lockpickView)
        view.backgroundColor = UIColor.brownColor();
        
        // copy the background color
        //view.backgroundColor = lockpickView.backgroundColor*/
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

}

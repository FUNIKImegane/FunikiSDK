//
//  Created by Matilde Inc.
//  Copyright (c) 2015 FUN'IKI Project. All rights reserved.
//

import UIKit

class FunikiSDKMotionViewController: UIViewController, MAFunikiManagerDelegate, MAFunikiManagerDataDelegate {
    
    let funikiManager = MAFunikiManager.sharedInstance()
    
    var baseSize:CGRect!
    var accXRect:CGRect!
    var accYRect:CGRect!
    var accZRect:CGRect!
    var rotXRect:CGRect!
    var rotYRect:CGRect!
    var rotZRect:CGRect!
    
    @IBOutlet var accXView:UIView!
    @IBOutlet var accYView:UIView!
    @IBOutlet var accZView:UIView!
    @IBOutlet var rotXView:UIView!
    @IBOutlet var rotYView:UIView!
    @IBOutlet var rotZView:UIView!
    
    @IBOutlet var sensorSwitch:UISwitch!

    // MARK: - UIViewController
    override func viewDidLoad() {
        baseSize = accXView.frame
        baseSize.size.width = baseSize.size.width / 2
        
        accXRect = accXView.frame
        accYRect = accYView.frame
        accZRect = accZView.frame
        
        rotXRect = rotXView.frame
        rotYRect = rotYView.frame
        rotZRect = rotZView.frame
        
        setBarHidden(true)
    }
        
    override func viewWillAppear(animated: Bool) {
        funikiManager.delegate = self
        funikiManager.dataDelegate = self
        
        self.updateSensorSwitch()
        
        super.viewWillAppear(animated)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // MARK: -
    func setBarHidden(hidden:Bool) {
        accXView.hidden = hidden
        accYView.hidden = hidden
        accZView.hidden = hidden
        
        rotXView.hidden = hidden
        rotYView.hidden = hidden
        rotZView.hidden = hidden
    }
    
    func updateSensorSwitch() {
        if funikiManager.connected {
            sensorSwitch.enabled = true
        }
        else {
            sensorSwitch.enabled = false
            sensorSwitch.setOn(false, animated: true)
        }
    }
    
    // MARK: - MAFunikiManagerDelegate
    func funikiManagerDidConnect(manager: MAFunikiManager!) {
        
        print("SDK Version\(MAFunikiManager.funikiSDKVersionString())")
        print("Firmware Revision\(manager.firmwareRevision)")
        
        updateSensorSwitch()
    }
    
    func funikiManagerDidDisconnect(manager: MAFunikiManager!, error: NSError!) {
        if let actualError = error {
            print(actualError)
        }
        updateSensorSwitch()
    }
    
    func funikiManager(manager: MAFunikiManager!, didUpdateCentralState state: CBCentralManagerState) {
        updateSensorSwitch()
    }
    
    // MARK: - MAFunikiManagerDataDelegate
    func funikiManager(manager: MAFunikiManager!, didUpdateMotionData motionData: MAFunikiMotionData!) {
        
        accXRect.size.width = CGFloat(motionData.acceleration.x) * baseSize.size.width
        accYRect.size.width = CGFloat(motionData.acceleration.y) * baseSize.size.width
        accZRect.size.width = CGFloat(motionData.acceleration.z) * baseSize.size.width
        rotXRect.size.width = ((CGFloat(motionData.rotationRate.x) * baseSize.size.width) / 250.0) * 2.0
        rotYRect.size.width = ((CGFloat(motionData.rotationRate.y) * baseSize.size.width) / 250.0) * 2.0
        rotZRect.size.width = ((CGFloat(motionData.rotationRate.z) * baseSize.size.width) / 250.0) * 2.0
        
        self.accXView.frame = accXRect
        self.accYView.frame = accYRect
        self.accZView.frame = accZRect
        self.rotXView.frame = rotXRect
        self.rotYView.frame = rotYRect
        self.rotZView.frame = rotZRect
    }
    
    func funikiManager(manager: MAFunikiManager!, didPushButton buttonEventType: MAFunikiManagerButtonEventType) {
        
        var string = "ButtonEventType"
        switch (buttonEventType){
        case .SinglePush:
            string = "ButtonEventTypeSinglePush"
            break
            
        case .DoublePush:
            string = "ButtonEventTypeDoublePush"
            
        default:
            string = "ButtonEventTypeUnknown"
            break
        }
        
        let alertView = UIAlertView(title: "DidPushButton", message: string, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    // MARK: - Action
    @IBAction func switchDidChange(sender:UISwitch!) {
        
        if sensorSwitch.on {
            funikiManager.startMotionSensor()
            setBarHidden(false)
        }
        else {
            funikiManager.stopMotionSensor()
            setBarHidden(true)
        }
    }
}


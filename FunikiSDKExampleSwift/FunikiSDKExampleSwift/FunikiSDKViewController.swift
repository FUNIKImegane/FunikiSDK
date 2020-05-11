//
//  Created by Matilde Inc.
//  Copyright (c) 2015 FUN'IKI Project. All rights reserved.
//

import UIKit

class FunikiSDKViewController: UIViewController, MAFunikiManagerDelegate, MAFunikiManagerDataDelegate {

    let funikiManager = MAFunikiManager.sharedInstance()
    
    @IBOutlet var volumeSegmentedControl:UISegmentedControl!
    @IBOutlet var frequencySlider:UISlider!
    @IBOutlet var frequencyLabel:UILabel!
    @IBOutlet var connectionLabel:UILabel!
    @IBOutlet var batteryLabel:UILabel!
    @IBOutlet weak var sdkVersionLabel: UILabel!

    // MARK: -
    func updateConnectionStatus() {
        if (funikiManager?.isConnected)! {
            self.connectionLabel.text = "接続済み"
        }else {
            self.connectionLabel.text = "未接続"
        }
    }
    
    func updateBatteryLevel(){
        
        let batt:MAFunikiManagerBatteryLevel = (funikiManager?.batteryLevel)!
        
        switch batt {
        case .low:
            self.batteryLabel.text = "バッテリー残量:少ない"
            
        case .medium:
            self.batteryLabel.text = "バッテリー残量:中"
            
        case .high:
            self.batteryLabel.text = "バッテリー残量:多い"

        case .unknown:
            fallthrough
        @unknown default:
            self.batteryLabel.text = "バッテリー残量:不明"
        }
    }

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.volumeSegmentedControl.selectedSegmentIndex = 2
        self.sdkVersionLabel.text = "SDK Version:" + MAFunikiManager.funikiSDKVersionString()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
   
        funikiManager?.delegate = self
        funikiManager?.dataDelegate = self
        
        updateConnectionStatus()
        updateBatteryLevel()
        buzzerFrequencyChanged(nil)
        
        super.viewWillAppear(animated)
    }
    

    // MARK: - MAFunikiManagerDelegate
    func funikiManagerDidConnect(_ manager: MAFunikiManager!) {
        print("SDK Version\(MAFunikiManager.funikiSDKVersionString()!)")
        print("Firmware Revision\(manager.firmwareRevision!)")
        updateConnectionStatus()
        updateBatteryLevel()
    }
    
    func funikiManagerDidDisconnect(_ manager: MAFunikiManager!, error: Error!) {

        if let actualError = error {
            print(actualError)
        }
        updateConnectionStatus()
        updateBatteryLevel()
    }
    
    func funikiManager(_ manager: MAFunikiManager!, didUpdate batteryLevel: MAFunikiManagerBatteryLevel) {
        updateBatteryLevel()
    }
    
    func funikiManager(_ manager: MAFunikiManager!, didUpdateCentralState state: CBCentralManagerState) {
        updateConnectionStatus()
        updateBatteryLevel()
    }
    
    // MARK: - MAFunikiManagerDataDelegate
    func funikiManager(_ manager: MAFunikiManager!, didUpdate motionData: MAFunikiMotionData!) {
        print(motionData!)
    }
    
    func funikiManager(_ manager: MAFunikiManager!, didPushButton buttonEventType: MAFunikiManagerButtonEventType) {
        
    }
    
    @IBAction func red(_ sender: UIButton) {
        if (funikiManager?.isConnected)!{
            funikiManager?.changeLeftColor(UIColor.red, rightColor: UIColor.red, duration: 1.0, buzzerFrequency: freqFromSlider(), buzzerVolume: selectedBuzzerVolume())
        }
    }
    
    @IBAction func green(_ sender:UIButton) {
        if (funikiManager?.isConnected)!{
            funikiManager?.changeLeftColor(UIColor.green, rightColor: UIColor.green, duration: 1.0, buzzerFrequency: freqFromSlider(), buzzerVolume: selectedBuzzerVolume())
        }
    }
    
    @IBAction func blue(_ sender:UIButton) {
        if (funikiManager?.isConnected)!{
            funikiManager?.changeLeftColor(UIColor.blue, rightColor: UIColor.blue, duration: 1.0, buzzerFrequency: freqFromSlider(), buzzerVolume: selectedBuzzerVolume())
        }
    }
    
    @IBAction func stop(_ sender:UIButton) {
        funikiManager?.changeLeftColor(UIColor.black, rightColor: UIColor.black, duration: 1.0)
    }
    
    @IBAction func buzzerFrequencyChanged(_ sender:Any!) {
        frequencyLabel.text = NSString(format: "%0.0ld", freqFromSlider()) as String
    }
    
    // MARK: - UI->Value
    func selectedBuzzerVolume () -> MAFunikiManagerBuzzerVolume {
        
        let selectedSegmentIndex = volumeSegmentedControl.selectedSegmentIndex
        var volume:MAFunikiManagerBuzzerVolume!
        
        switch(selectedSegmentIndex){
        case 0:
            volume = .mute
        case 1:
            volume = .low
        case 2:
            volume = .medium
        case 3:
            volume = .loud
        default:
            volume = .mute
        }
        return volume!
    }
    
    func freqFromSlider()-> Int {
        let value:Int = Int(pow(self.frequencySlider.value, 2.0))
        // 雰囲気メガネが発音可能な周波数に丸めます
        return funikiManager!.roundedBuzzerFrequency(value)
    }
}


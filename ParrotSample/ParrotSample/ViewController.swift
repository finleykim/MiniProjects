//
//  ViewController.swift
//  ParrotSample
//
//  Created by finley on 2022/12/15.
//

import UIKit

class ViewController: UIViewController, BPHeadsetListener {

    var headset: BPHeadset!
    private var lastDisconnect: NSDate!
    
    @IBOutlet weak var connectBtn: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var logTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headset = BPHeadset.sharedInstance()
        headset.add(self)
        self.checkHeadsetStatus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func checkHeadsetStatus() {
        if headset.connected {
            connectBtn.setTitle("Disconnect", for: .normal)
//            sdkModeButton.hidden = false
//            bondableButton.hidden = false
//            enterpriseView.hidden = false
            if headset.sdkModeEnabled {
//                sdkModeButton.setTitle("Disable SDK Mode", forState:UIControlStateNormal)
            } else {
//                sdkModeButton.setTitle("Enable SDK Mode", forState:UIControlStateNormal)
            }

            if headset.bondableEnabled == BPBondable.enabled {
//                bondableButton.setTitle("Disable Bondable", forState:UIControlStateNormal)
            } else {
//                bondableButton.setTitle("Enable Bondable", forState:UIControlStateNormal)
            }
        } else {
            connectBtn.setTitle("Connect", for: .normal)
//            sdkModeButton.hidden = true
//            bondableButton.hidden = true
//            enterpriseView.hidden = true
        }
    }
    
    @IBAction func connetBtnTapped(_ sender: UIButton) {
        if headset?.connected == true {
            headset?.disconnect()
        } else {
            headset?.connect()
            connectBtn.tintColor = .white
        }
    }

    func onModeUpdate() {
        self.addStatus("Headset mode set successfully")
        self.checkHeadsetStatus()
    }

    func onConnectProgress(status:BPConnectProgress) {
        switch (status) {
        case BPConnectProgress.started:
                self.addStatus("Started connecting...")
                break
        case BPConnectProgress.scanning:
                self.addStatus("Scanning for headsets...")
                break
        case BPConnectProgress.found:
                self.addStatus("Headset Found...")
                break
        case BPConnectProgress.reading:
                self.addStatus("Reading headset values...")
                break

            default:
                break
        }
    }

    func onModeUpdateFailure(_ error:BPModeUpdateError) {
        self.addStatus("Headset mode set error")
        self.checkHeadsetStatus()
    }

    func onConnect() {
//        let msg: String! = String(format:"Headset (%@) connected, current mode: %ld", headset.friendlyName, headset.buttonMode as! CVarArg)
        let msg = "Headset \(String(describing: headset.friendlyName)) connected, current mode: \(headset.buttonMode)"
        self.addStatus(msg)
    }

    func onValuesRead() {
        var fw:String! = headset.firmwareVersion
        if fw == nil {
            fw = "Unknown"
        }
        var msg:String! = String(format:"Finished reading headset values, firmware version: %@", fw)
        self.addStatus(msg)
//        msg = String(format:"Proximity state: %ld", (headset.proximityState as! CVarArg))
        msg = "Proximity state: ???"
        self.addStatus(msg)
//        msg = String(format:"Bondable: %ld", (headset.bondableEnabled as! CVarArg))
        msg = "Bondable: ???"
        self.addStatus(msg)
        msg = self.describeMode()
        self.addStatus(msg)
        self.checkHeadsetStatus()
        connectBtn.isEnabled = true
        lastDisconnect = nil
    }

    func onConnectFailure(reasonCode:BPConnectError) {
        switch (reasonCode) {
        case BPConnectError.bluetoothDisabled:
                self.addStatus("Headset failed to connect - Bluetooth Disabled")
                break
        case BPConnectError.sdkTooOld:
                self.addStatus("Headset failed to connect - SDK is too old for the headset")
                break
        case BPConnectError.firmwareTooOld:
                self.addStatus("Headset failed to connect - Firmware too old")
                break
        case BPConnectError.unknown:
                self.addStatus("Headset failed to connect - unknown")
                break
        default:
                self.addStatus("Headset failed to connect - unknown reason")
                break
        }
        self.checkHeadsetStatus()
        connectBtn.isEnabled = true
    }

    func onDisconnect() {
        self.addStatus("Headset disconnected")
        self.checkHeadsetStatus()
        connectBtn.isEnabled = true
        if (lastDisconnect != nil) {
            let diff:TimeInterval = fabs(lastDisconnect.timeIntervalSinceNow)
            if diff < 3 {
                lastDisconnect = nil
                headset.disconnect()
                let alert:UIAlertController! = UIAlertController(title: "Error",
                                                                               message:"Headset was disconnected, possibly due to a bonding error. Try unpairing the device and pairing again.",
                                                                                          preferredStyle: UIAlertController.Style.alert)

                let cancel: UIAlertAction! = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alert.addAction(cancel)
                //self.presen(alert, animated:true, completion:nil)
            }
        }
        lastDisconnect = NSDate()
    }

    private func onTap(buttonID:BPButtonID) {
        self.addStatus("Headset onSingleTap")
        self.showToast("Single Tap")
    }

    private func onDoubleTap(buttonID:BPButtonID) {
        self.addStatus("Headset onDoubleTap")
        self.showToast("Double Tap")
    }

    private func onLongPress(buttonID:BPButtonID) {
        self.addStatus("Headset onButtonLongPress")
        self.showToast("Long Press")
    }

    private func onProximityChanged(proximityState:BPProximityState) {
//        let status:String! = String(format:"Headset proximity changed: %ld", (proximityState as! CVarArg))
        let status = "Headset proximity changed: ???"
        self.addStatus(status)
    }


    private func onButtonDown(buttonID: BPButtonID) {
        let status:String! = String(format:"Headset onButtonDown")
        self.addStatus(status)
        self.view.backgroundColor = .green
    }

    private func onButtonUp(buttonID: BPButtonID) {
        let status:String! = String(format:"Headset onButtonUp")
        self.addStatus(status)
        self.view.backgroundColor = .white
    }


    // MARK: -
    // MARK: On Screen Logging

    func showToast(_ text:String!) {
        let alert = UIAlertAction(title: text, style: UIAlertAction.Style.default)
        
//        self.presentedViewController(alert, animated: true, completion: nil)

        let duration:Int = 2 // seconds

    }

    func setStatus(_ text:String!) {
        statusLabel.text = text
        return
    }

    func addStatus(_ text:String!) {
        NSLog("%@", text)

        var oldText:String! = logTextView.text

        let dateFormatter = DateFormatter()
//        dateFormatter.calendar = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian) as Calendar?
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        let now = Date()
        let timestamp = dateFormatter.string(from: now)
        

        let newLine:String! = String(format:"%@: %@", timestamp, text)

        if (oldText != nil) && oldText.count > 0 {
            oldText = oldText + "/n"
        }

//        let newText:String! = oldText.stringByAppendingString(newLine)
        let newText = oldText + newLine
        logTextView.text = newText
        let range:NSRange = NSMakeRange(logTextView.text.count - 1, 1)
        logTextView.scrollRangeToVisible(range)
    }


    func describeMode() -> String! {
        var description:String! = nil
        let mode:BPButtonMode = headset.buttonMode
        let sdkEnabled:Bool = headset.sdkModeEnabled
        let appID:String! = headset.appKey
        let appName:String! = headset.appName
        let speedDial:String! = headset.speedDialNumber

        if sdkEnabled {
            description = String(format:"SDK Mode, App Name: %@", appName)
            return description
        }

        switch (mode) {
            case BPButtonMode.app:
                description = String(format:"App Mode, App ID: %@, App Name: %@", appID, appName)
                break
            case BPButtonMode.mute:
                description = String(format:"Mute Mode")
                break
            case BPButtonMode.speedDial:
                description = String(format:"Speed Dial Mode (%@)", speedDial)
                break
            default:
//                description = String(format:"Unknown Mode (%ld)", (mode as! CVarArg))
            description = "Unknown Mode"
                break
        }
        return description
    }
    
}


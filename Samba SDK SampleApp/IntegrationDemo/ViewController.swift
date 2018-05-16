//
//  ViewController.swift
//  IntegrationDemo
//
//  Created by Mihai Versan on 2/26/18.
//  Copyright © 2018 SambaNetworks. All rights reserved.
//

import UIKit
import SambaSDK

class ViewController: UIViewController {

    @IBOutlet weak var secretKey: UILabel!
    @IBOutlet weak var publisherId: UILabel!
    @IBOutlet weak var initBtn: UIButton!
    @IBOutlet weak var loadBtn: UIButton!
    @IBOutlet weak var showBtn: UIButton!
    @IBOutlet weak var optimizeDownloadOnMobileData: UISwitch!
    @IBOutlet weak var disableVideoSoundAtStart: UISwitch!
    @IBOutlet weak var errorLabel: UILabel!
    
    //  Keep an instance of Samba Ad Manager.
    var adManager : AdManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBtn.addTarget(self, action: #selector(self.initButtonClicked), for: .touchUpInside)
        loadBtn.addTarget(self, action: #selector(self.loadButtonClicked), for: .touchUpInside)
        showBtn.addTarget(self, action: #selector(self.showButtonClicked), for: .touchUpInside)
        
        showBtn.isEnabled = false
        loadBtn.isEnabled = false
        errorLabel.text = ""
    }
    
    @objc func initButtonClicked() {
        let optimizeDownloadOnMobileData = self.optimizeDownloadOnMobileData.isOn
        let disableVideoSoundAtStart = self.disableVideoSoundAtStart.isOn
        
        // Use/generate a unique ID for the current user
        let userId = UUID().uuidString
        let publisherId = 0
        let secretKey = "YourSecretKey"
 
        //  Configurate SambaSetup
        let sambaSetup = SambaSetup(userId: userId, publisherId: publisherId, secretKey: secretKey)
        
        let gender = Gender.male
        let age = 25
        let target = Target()
        target.age = age
        target.gender = gender
        
        let isSoundEnabled = !disableVideoSoundAtStart
        let screenOrientation = Orientation.auto
        
        //  Create video configuration
        let videoConfig = VideoConfig(screenOrientation: screenOrientation, soundEnabled: isSoundEnabled, optimizeDownloadOnMobileData: optimizeDownloadOnMobileData)
        
        //  After we got all the data we can configure Samba
        Samba.configure(setup: sambaSetup, videoConfig: videoConfig, target: target)
        
        //  Initialize the ad manager
        self.adManager = Samba.adManager
        
        //  Set delegate in order to receive events (adDidLoad, adDidAppear, adDidReachEnd etc)
        self.adManager?.delegate = self
        
        updateUI(secretKey: secretKey, publisherId: publisherId)
    }
    
    fileprivate func updateUI(secretKey: String, publisherId: Int) {
        guard let adManager = self.adManager else {
            return
        }
        
        self.secretKey.text = secretKey
        self.publisherId.text = String(publisherId)
        
        //  You should always check if ad is ready before showing it
        showBtn.isEnabled = adManager.state == .readyToShow
        loadBtn.isEnabled = adManager.state == .readyToLoad
    }
    
    @objc func loadButtonClicked() {
        loadBtn.isEnabled = false
        
        //  Call loadAd method when you want to receive content
        self.adManager?.loadAd()
    }

    @objc func showButtonClicked() {
        //  When content is ready you can call showAd method for showing the ad
        self.adManager?.showAd(from: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: AdManagerProtocol {
    
    //  Method called when the Samba Ad finished loading
    func sambaAdDidLoad(_ adManager: AdManager) {
        self.errorLabel.text = ""
        self.showBtn.isEnabled = true
        self.loadBtn.isEnabled = false
    }
    
    func sambaAd(_ adManager: AdManager, didFailToLoad error: SambaError) {
        self.errorLabel.text = error.localizedDescription
        self.loadBtn.isEnabled = true
        self.showBtn.isEnabled = false
    }
    
    func sambaAdDidDisappear(_ adManager: AdManager) {
        self.loadBtn.isEnabled = true
        self.showBtn.isEnabled = false
    }
    
    func sambaAd(_ adManager: AdManager, didReachEnd adCompleted: Bool) {
        
    }
    
    //  Method called when the user tries to play an ad with age restriction and he is under 18
    func ageRestrictionNotMet(_ adManager: AdManager) {
        self.errorLabel.text = "You must be over 18 to watch the ads."
        self.showBtn.isEnabled = false
        self.loadBtn.isEnabled = true
    }
}



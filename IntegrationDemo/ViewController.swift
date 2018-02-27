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
    
    lazy var manager = Samba.adManager!
    
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
        
        let userId = "abcdef"
        let publisherId = 14
        let secretKey = "TextMeSecretKey"
        
        let sambaSetup = SambaSetup(userId: userId, publisherId: publisherId, secretKey: secretKey)
        
        let gender = Gender.male
        let age = 25
        let target = Target(age: age, gender: gender)
        
        let isSoundEnabled = !disableVideoSoundAtStart
        let screenOrientation = Orientation.auto
        let videoConfig = VideoConfig(screenOrientation: screenOrientation, soundEnabled: isSoundEnabled, optimizeDownloadOnMobileData: optimizeDownloadOnMobileData)
        
        Samba.configure(setup: sambaSetup, videoConfig: videoConfig, target: target)
        
        updateUI(secretKey: secretKey, publisherId: publisherId)
    }
    
    fileprivate func updateUI(secretKey: String, publisherId: Int) {
        self.secretKey.text = secretKey
        self.publisherId.text = String(publisherId)
        
        showBtn.isEnabled = self.manager.isReady
        loadBtn.isEnabled = (!self.manager.isLoading && !self.manager.isReady)
        self.manager.delegate = self
    }
    
    @objc func loadButtonClicked() {
        loadBtn.isEnabled = false
        
        self.manager.loadAd()
    }

    @objc func showButtonClicked() {
        self.manager.showAd(from: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: AdManagerProtocol {
    func sambaAdDidLoad(_ adManager: AdManager) {
        DispatchQueue.main.async {
            self.errorLabel.text = ""
            self.showBtn.isEnabled = true
            self.loadBtn.isEnabled = false
        }
    }
    
    func sambaAd(_ adManager: AdManager, didFailToLoad error: SambaError) {
        DispatchQueue.main.async {
            self.errorLabel.text = error.localizedDescription
            self.loadBtn.isEnabled = true
            self.showBtn.isEnabled = false
        }
    }
    
    func sambaAdDidDisappear(_ adManager: AdManager) {
        DispatchQueue.main.async {
            self.loadBtn.isEnabled = true
            self.showBtn.isEnabled = false
        }
    }
    
    func sambaAd(_ adManager: AdManager, didReachEnd adCompleted: Bool) {
        
    }
    
    func ageRestrictionNotMet(_ adManager: AdManager) {
        DispatchQueue.main.async {
            self.errorLabel.text = "You must be over 18 to watch the ads."
            self.showBtn.isEnabled = false
            self.loadBtn.isEnabled = true
        }
    }
}



//
//  SetPermissionsViewController.swift
//  NearbyWeather
//
//  Created by Erik Maximilian Martens on 15.04.17.
//  Copyright © 2017 Erik Maximilian Martens. All rights reserved.
//

import UIKit

class SetPermissionsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var timer: Timer!
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var warningImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var askPermissionsButton: UIButton!
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.title = NSLocalizedString("SetPermissionsVC_NavigationBarTitle", comment: "")
        
        NotificationCenter.default.addObserver(self, selector: #selector(SetPermissionsViewController.launchApp), name: Notification.Name(rawValue: NotificationKeys.locationAuthorizationUpdated.rawValue), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: (#selector(SetPermissionsViewController.timerEnded)), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer.invalidate()
    }
    
    /* Deinitializer */
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Helper Functions
    
    func configure() {
        navigationController?.navigationBar.styleStandard(withTransluscency: false, animated: true)
        navigationController?.navigationBar.addDropAnimation(withVignetteSize: 10)
        navigationController?.navigationBar.setDropShadow(offSet: CGSize(width: 0, height: 1), radius: 10)
        
        bubbleView.layer.cornerRadius = 10
        bubbleView.backgroundColor = .black
        bubbleView.setDropShadow(offSet: CGSize(width: 0, height: 1), radius: 10)
        
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        descriptionLabel.textColor = .white
        descriptionLabel.text! = NSLocalizedString("SetPermissionsVC_Description", comment: "")
        
        askPermissionsButton.setTitle(NSLocalizedString("SetPermissionsVC_AskPermissionsButtonTitle", comment: "").uppercased(), for: .normal)
        askPermissionsButton.setTitleColor(.nearbyWeatherStandard, for: .normal)
        askPermissionsButton.setTitleColor(.nearbyWeatherBubble, for: .highlighted)
        askPermissionsButton.layer.cornerRadius = 5.0
        askPermissionsButton.layer.borderColor = UIColor.nearbyWeatherStandard.cgColor
        askPermissionsButton.layer.borderWidth = 1.0
    }
    
    @objc private func timerEnded() {
        warningImageView.shake()
    }
    
    @objc func launchApp() {
        WeatherService.attachPersistentObject()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyboard.instantiateInitialViewController()
        
        UIApplication.shared.keyWindow?.rootViewController = destinationViewController
    }
    
    
    // MARK: - Button Interaction
    
    @IBAction func didTapAskPermissionsButton(_ sender: UIButton) {
        if LocationService.current.authorizationStatus == .notDetermined {
            LocationService.current.requestWhenInUseAuthorization()
        } else {
            launchApp()
        }
    }
}

//
//  ViewController.swift
//  TaskTape AR Features
//
//  Created by Chris Mathias on 7/15/18.
//  Copyright © 2018 SolipsAR. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import ARCL
import CoreLocation

class JobFinderViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    var infoLabel = UILabel()
    var sceneLocationView = SceneLocationView()
    
    var displayDebugging = true
    var updateInfoLabelTimer: Timer?
    var userLocation:CLLocation!
    
    /// Marks if the AR experience is available for restart.
    var isRestartAvailable = true
    
    static func storyboardInstance() -> JobFinderViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JobFinderViewController") as! JobFinderViewController
    }
    
    // Hook up status view controller callback(s).
    lazy var statusViewController: StatusViewController = {
        return childViewControllers.lazy.flatMap({ $0 as? StatusViewController }).first!
    }()
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
//        sceneView.delegate = self
//        sceneView.session.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }        
        
        setupARCL()

        initLocationManager()
    }
    
    func initLocationManager() {
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        //        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
        if (authorizationStatus != .authorizedWhenInUse) {
            print("User has not authorized access to location information.")
            //TODO: Pleasant "feature is unavailable" and slide back to calling view
            return
        }
        
        //Force an initial value for "distance" then use significant change after.
        startReceivingLocationChanges()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.locationManager.stopUpdatingLocation()
            self.startReceivingSignificantLocationChanges()
        })
        
    }
    
    func startReceivingLocationChanges() {

        // Do not start services that aren't available.
        if (!CLLocationManager.locationServicesEnabled()) {
            print("Location information not available for some reason.")
            //TODO: Present "feature is unavailable" and slide back to calling view
            // Location services is not available.
            return
        }
        
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 100.0  // In meters.
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.startUpdatingLocation()
    }
    
    func startReceivingSignificantLocationChanges() {

        if (!CLLocationManager.significantLocationChangeMonitoringAvailable()) {
            print("Location information not available for some reason.")
            //TODO: Present "feature is unavailable" and slide back to calling view
            // Location services is not available.
            return
        }
        
        locationManager.delegate = self
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
        infoLabel.frame = CGRect(x: 6, y: 0, width: self.view.frame.size.width - 12, height: 14 * 4)
        
        infoLabel.frame.origin.y = self.view.frame.size.height - infoLabel.frame.size.height

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        resetTracking()

        sceneLocationView.run()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        session.pause()
        sceneLocationView.pause()
        locationManager.stopUpdatingLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func resetTracking() {
        
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = [.horizontal, .vertical]
//        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
//        statusViewController.scheduleMessage("Move the device slowly to look for TaskTape Areas", inSeconds: 1.5, messageType: .planeEstimation)
        
    }

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

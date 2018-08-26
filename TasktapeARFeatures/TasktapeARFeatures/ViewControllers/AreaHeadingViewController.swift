//
//  AreaHeadingViewController
//  TaskTape AR Features
//
//  Created by Chris Mathias on 7/15/18.
//  Copyright © 2018 SolipsAR. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation

class AreaHeadingViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    var displayDebugging = true
    var arrowIsShowing = false
    var userLocation:CLLocation!
    
    /// Marks if the AR experience is available for restart.
    var isRestartAvailable = true
    
    var arrowNode:SCNNode!
    
    static func storyboardInstance() -> AreaHeadingViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AreaHeadingViewController") as! AreaHeadingViewController
    }
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    var locationManager = CLLocationManager()
    var targetLocation:CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLocationManager()

        resetTracking()
        
        //Would come from the selected area in the UI, in the actual app.
        let job = JobData.jobs[0]//TODO use locations[0] from selected job.
        
        let lat = CLLocationDegrees((job.address?.geolocation?.lat)!)//TODO: This should be Area in practice. For demo of bearing arrow...sok.
        let lng = CLLocationDegrees((job.address?.geolocation?.lng)!)
        
        targetLocation = CLLocation(latitude: lat, longitude: lng)        
        
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
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter = 10.0  // In meters.
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()        
        locationManager.startUpdatingHeading()
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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        // Create a session configuration
        restartExperience()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        session.pause()
        locationManager.stopUpdatingLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}

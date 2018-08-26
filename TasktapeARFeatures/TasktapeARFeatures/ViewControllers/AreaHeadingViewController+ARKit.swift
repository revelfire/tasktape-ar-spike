import UIKit
import SceneKit
import SpriteKit
//import ARCL
import ARKit
import CoreLocation

extension AreaHeadingViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        print("Location update: \(locations.last!)")
        userLocation = locations.last!
        
        let distanceToSite = targetLocation.distance(from: userLocation).rounded()
        let distanceInFeet = (distanceToSite * 3.28084).rounded()
        print("Distance: \(distanceInFeet) feet")
        
        if (distanceInFeet < 20) {
            print("Now would be a good time to indicate 'there-ness' to the user by changing the arrow to a Tape Icon, that when tapped, takes the user to the Area UX")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        updateArrowDirectionality(newHeading)
    }
}
extension AreaHeadingViewController : ARSCNViewDelegate, ARSessionDelegate {
    
    func initializeBearingArrow() -> SCNNode {        
        
        let arrowPath = UIBezierPath.arrow(from: CGPoint(x: 0, y:4), to: CGPoint(x: 0, y: 0), tailWidth: 1, headWidth: 3, headLength: 2)
        let arrowShape = SCNShape(path: arrowPath, extrusionDepth: CGFloat(0.2))
//        arrowShape.firstMaterial?.diffuse.contents = UIColor.blue
        let arrowMaterial = SCNMaterial()
        arrowMaterial.diffuse.contents = UIImage(named: "Assets.xcassets/tapeLargeIcon")
        arrowShape.materials = [arrowMaterial]
        arrowShape.firstMaterial?.diffuse.contents = UIColor.blue

        let arrowNode = SCNNode(geometry: arrowShape)
        arrowNode.name = "bearing_arrow"
        
        return arrowNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        renderArrow()
    }
    
    func hideArrow() {
        arrowNode.removeFromParentNode()
        arrowIsShowing = false
    }

    func renderArrow() {
        
        guard let arrowNode = arrowNode else { return }
        arrowNode.scale = SCNVector3(0.1, 0.1, 0.1)
        arrowNode.position = SCNVector3(0, 0, -1)
        sceneView.pointOfView?.addChildNode(arrowNode)
        arrowIsShowing = true
        
//        arrowNode.runAction(SCNAction.rotateBy(x: arrowNode.position.x, y: arrowNode.position.y, z: z, duration: 0.0))
        arrowNode.runAction(SCNAction.rotateBy(x: CGFloat(Double(110).degreesToRadians), y: 0, z: 0, duration: 0.5))
 
//        let gradientLayer = CAGradientLayer()
        

//        if let userLocation = userLocation { //sceneLocationView.currentLocation() {
//
//        }
        
    }
    
    func updateArrowDirectionality(_ heading: CLHeading) {
        print("New heading: \(heading)")
        
        //https://www.movable-type.co.uk/scripts/latlong.html
        //Calculate heading based on where the "Area" is
        //Translate position of location relative to device location (as lat/lng coords) into a "bearing" 0-360
        let bearing = userLocation.bearing(to: targetLocation)
        
        print("Bearing to target Area is: \(bearing)")
        
        //Subtract that bearing from self.heading (careful to honor the 0/360 mark)
        
        print("Rotation for heading is: \(getHeadingForRotation(heading: heading, bearing: bearing))")
        
        
        //Keep the arrow pointed to that heading
        
        //Extra points for changing the size of the arrow relative to the distance :)
        arrowNode.runAction(SCNAction.rotateTo(x: CGFloat(Double(110).degreesToRadians), y: CGFloat(getHeadingForRotation(heading: heading, bearing: bearing).degreesToRadians), z: 0, duration: 0))
        
    }
    
    func getHeadingForRotation(heading:CLHeading, bearing: Double) -> Double {
        //pretty sure this is incorrect. Reevaluate. Test.
        return (heading.magneticHeading - bearing + 360).truncatingRemainder(dividingBy: 360)
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
        
        let configuration = ARWorldTrackingConfiguration()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session.delegate = self

        //        configuration.planeDetection = [.horizontal, .vertical]
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

//        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]  //, .showWireframe
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.scene = SCNScene()
        
        arrowNode = initializeBearingArrow()
        
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
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        
        switch camera.trackingState {
        case .notAvailable, .limited:
            //            if (!isObjectVisible) {
//            statusViewController.escalateFeedback(for: camera.trackingState, inSeconds: 3.0)
        //            }
            print("Tracking limited or unavailable")
            hideArrow()
            
        case .normal:
            if (!arrowIsShowing) {
                renderArrow()
            }
            
//            statusViewController.cancelScheduledMessage(for: .trackingStateEscalation)
        }
    }
    
/// - Tag: restartExperience
    func restartExperience() {
        guard isRestartAvailable else { return }
        isRestartAvailable = false

        print("Starting (or reStarting) AR Experience!")

//        statusViewController.cancelAllScheduledMessages()
        
        // Disable restart for a while in order to give the session time to restart.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isRestartAvailable = true
        }
    }

}

//
//  CLLocationExtensions.swift
//  SwifterSwift
//
//  Created by Luciano Almeida on 21/04/17.
//  Copyright © 2017 SwifterSwift
//

#if canImport(CoreLocation)
import CoreLocation

// MARK: - Methods
public extension CLLocation {
    
    /// SwifterSwift: Calculate the half-way point along a great circle path between the two points.
    ///
    /// - Parameters:
    ///   - start: Start location.
    ///   - end: End location.
    /// - Returns: Location that represents the half-way point.
    public static func midLocation(start: CLLocation, end: CLLocation) -> CLLocation {
        let lat1 = Double.pi * start.coordinate.latitude / 180.0
        let long1 = Double.pi * start.coordinate.longitude / 180.0
        let lat2 = Double.pi * end.coordinate.latitude / 180.0
        let long2 = Double.pi * end.coordinate.longitude / 180.0
        
        // Formula
        //    Bx = cos φ2 ⋅ cos Δλ
        //    By = cos φ2 ⋅ sin Δλ
        //    φm = atan2( sin φ1 + sin φ2, √(cos φ1 + Bx)² + By² )
        //    λm = λ1 + atan2(By, cos(φ1)+Bx)
        // Source: http://www.movable-type.co.uk/scripts/latlong.html
        
        let bxLoc = cos(lat2) * cos(long2 - long1)
        let byLoc = cos(lat2) * sin(long2 - long1)
        let mlat = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + bxLoc) * (cos(lat1) + bxLoc) + (byLoc * byLoc)))
        let mlong = (long1) + atan2(byLoc, cos(lat1) + bxLoc)
        
        return CLLocation(latitude: (mlat * 180 / Double.pi), longitude: (mlong * 180 / Double.pi))
    }
    
    /// SwifterSwift: Calculate the half-way point along a great circle path between self and another points.
    ///
    /// - Parameter point: End location.
    /// - Returns: Location that represents the half-way point.
    public func midLocation(to point: CLLocation) -> CLLocation {
        return CLLocation.midLocation(start: self, end: point)
    }
    
    /// SwifterSwift: Calculates the bearing to another CLLocation.
    ///
    /// - Parameters:
    ///   - destination: Location to calculate bearing.
    /// - Returns: Calculated bearing degrees in the range 0° ... 360°
    public func bearing(to destination: CLLocation) -> Double {
        // http://stackoverflow.com/questions/3925942/cllocation-category-for-calculating-bearing-w-haversine-function
        let lat1 = Double.pi * coordinate.latitude / 180.0
        let long1 = Double.pi * coordinate.longitude / 180.0
        let lat2 = Double.pi * destination.coordinate.latitude / 180.0
        let long2 = Double.pi * destination.coordinate.longitude / 180.0
        
        //Formula: θ = atan2( sin Δλ ⋅ cos φ2 , cos φ1 ⋅ sin φ2 − sin φ1 ⋅ cos φ2 ⋅ cos Δλ )
        //Source: http://www.movable-type.co.uk/scripts/latlong.html
        
        let rads = atan2(
            sin(long2 - long1) * cos(lat2),
            cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(long2 - long1))
        let degrees = rads * 180 / Double.pi
        
        return (degrees+360).truncatingRemainder(dividingBy: 360)
    }
    
}
#endif

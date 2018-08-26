import UIKit
import SceneKit
import SpriteKit
import ARCL
import CoreLocation

extension JobFinderViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last!
        renderIndicons()
    }
}
extension JobFinderViewController {
    
    /// - Tag: ARCL
    
    func setupARCL() {
        
        infoLabel.font = UIFont.systemFont(ofSize: 10)
        infoLabel.textAlignment = .left
        infoLabel.textColor = UIColor.white
        infoLabel.numberOfLines = 0
        sceneLocationView.addSubview(infoLabel)
        
        updateInfoLabelTimer = Timer.scheduledTimer(
            timeInterval: 1, //0.1,
            target: self,
            selector: #selector(JobFinderViewController.updateInfoLabel),
            userInfo: nil,
            repeats: true)
        
        sceneLocationView.showAxesNode = true
        sceneLocationView.locationDelegate = self
                
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneLocationView.addGestureRecognizer(tapGestureRecognizer)
                
        initializeTapeIndicons()
        
        view.addSubview(sceneLocationView)
    }
    
    func initializeTapeIndicons() {
        guard isRestartAvailable else { return }
        isRestartAvailable = false
        
        statusViewController.cancelAllScheduledMessages()
        
        resetTracking()
        
        //Load data & then loop
        renderIndicons()
        
        
        // Disable restart for a while in order to give the session time to restart.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isRestartAvailable = true
        }
    }
    
    func renderIndicons() {
        //Load TT data for Jobs
        
        //Point jobs out in view with "job icon"
        
        //Load TT data for Areas
        
        //Point areas out in view with "tapes icon"

        
        for job in JobData.jobs {
            
            //This only works when we captured geo data. (AR mode was on)
            if let lat = job.address?.geolocation?.lat, lat > 0 {
                
                let jobViewNode = renderIndicon(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees((job.address?.geolocation?.lng)!), altitude: 149, imageName: "tapeLargeIcon")
                
                jobViewNode.annotationNode.addChildNode(createLabel(jobData: job, location: jobViewNode.location))
                
                sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: jobViewNode)

            }
            
        }
    }
    
    private func createLabel(jobData:JobData.Job, location: CLLocation) -> SCNNode {
        
        let skScene = SKScene(size: CGSize(width: 350, height: 350))
        skScene.backgroundColor = UIColor.white
        //        skScene.view?.layer.cornerRadius = 10
        //        skScene.view?.clipsToBounds = true
        
        let rectangle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 350, height: 350), cornerRadius: 10)
        rectangle.fillColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        rectangle.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        rectangle.lineWidth = 2
        rectangle.alpha = 0.8
        
        skScene.addChild(rectangle)
        
        let textSurround = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 350*UIScreen.main.scale, height: 170))
        //        textSurround.
        //        textSurround.fillColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        //        textSurround.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //        textSurround.lineWidth = 1
        //        textSurround.alpha = 1
        
        let fontSize = 40
        let fontName = "Avenir-Light"
        
        skScene.addChild(textSurround)
        
        //        instructionLabelNode.position = CGPoint(x:0,y:0)
        
        //Create a spritekit label for the data (todo: DistanceFrom)
        let jobNameLabel = SKLabelNode(fontNamed: fontName)  //TODO: This needs to be multi-line capable
        jobNameLabel.text = jobData.name
        jobNameLabel.fontSize = CGFloat(fontSize)
        jobNameLabel.fontColor = UIColor.white
        jobNameLabel.position = CGPoint( x: 5 , y: 45 )
        jobNameLabel.horizontalAlignmentMode = .left
        jobNameLabel.alpha = 1
        //Add label to the spritekit scene
        
        //        jobNameLabel.addChild(textSurround)
        
        textSurround.addChild(jobNameLabel)
        
        
        if let userLocation = userLocation { //sceneLocationView.currentLocation() {
            //Add distance to job
            let distanceLabel = SKLabelNode(fontNamed: fontName)
            let distanceToSite = location.distance(from: userLocation).rounded()
            let distanceInMiles = (distanceToSite * 0.000621371).rounded()
            distanceLabel.text = "Distance: \(distanceInMiles) miles"
            distanceLabel.fontSize = CGFloat(fontSize)
            distanceLabel.fontColor = UIColor.white
            
            distanceLabel.position = CGPoint( x: 5 , y: 5 )
            distanceLabel.horizontalAlignmentMode = .left
            //Add label to the spritekit scene
            skScene.addChild(distanceLabel)
            
        }
        
        do {
            if let jobImage = jobData.jobImage, let contentUrl = jobImage.contentUrl {
                let url = URL(string: contentUrl)
                
                let data = try Data(contentsOf: url! as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
                let theImage = UIImage(data: data)!.resizeImage(CGFloat(550), opaque: false)
                
                let texture = SKTexture(image: theImage)
                let jobImageSprite = SKSpriteNode(texture: texture)
                
                //Find center of image and use that
                let centerX = jobImageSprite.frame.width / 2
                let centerY = (jobImageSprite.frame.height / 2)
                jobImageSprite.position = CGPoint( x: centerX, y:centerY)//  theImage.topCapHeight / 2  )
                jobImageSprite.alpha = 0.6
                
                skScene.addChild(jobImageSprite)
            }
        } catch let error as NSError {
            // error
            print("Error loading job image: \(error)")
        }
        
        //TODO: Add job image if we can...external url :/
        
        //Add the spritekit scene to a scenekit plane
        let plane = SCNPlane(width: 1.5, height: 1.5)
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.diffuse.contents = skScene
        //Flip to face forward
        material.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
        plane.materials = [material]
        
        let currentJobViewNode = SCNNode(geometry: plane)
        
        currentJobViewNode.position = SCNVector3Make(currentJobViewNode.position.x, currentJobViewNode.position.y - 0.75, currentJobViewNode.position.z)
        currentJobViewNode.name = jobData.jobUuid
        
        return currentJobViewNode
        
    }
    
    func renderIndicon(latitude: CLLocationDegrees, longitude: CLLocationDegrees, altitude: CLLocationDistance, imageName: String) -> LocationAnnotationNode {
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude)
        
        let imageAsDataSoWeCanScaleIt = UIImagePNGRepresentation(UIImage(named: imageName)!)
        let image = UIImage(data: imageAsDataSoWeCanScaleIt!, scale: CGFloat(3))!
        return LocationAnnotationNode(location: location, image: image)
    }
    
    @objc func updateInfoLabel() {
//        if let position = sceneLocationView.currentScenePosition() {
//            infoLabel.text = "x: \(String(format: "%.2f", position.x)), y: \(String(format: "%.2f", position.y)), z: \(String(format: "%.2f", position.z))\n"
//        }
        
//        if let eulerAngles = sceneLocationView.currentEulerAngles() {
    //            infoLabel.text!.append("Euler x: \(String(format: "%.2f", eulerAngles.x)), y: \(String(format: "%.2f", eulerAngles.y)), z: \(String(format: "%.2f", eulerAngles.z))\n")
//        }
        
//        if let heading = sceneLocationView.locationManager.heading,
//            let accuracy = sceneLocationView.locationManager.headingAccuracy {
//            infoLabel.text!.append("Heading: \(heading)º, accuracy: \(Int(round(accuracy)))º\n")
//        }
        
//        let date = Date()
//        let comp = Calendar.current.dateComponents([.hour, .minute, .second, .nanosecond], from: date)
        
//        if let hour = comp.hour, let minute = comp.minute, let second = comp.second, let nanosecond = comp.nanosecond {
//            infoLabel.text!.append("\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", second)):\(String(format: "%03d", nanosecond / 1000000))")
//        }
    }
    
}

// MARK: - SceneLocationViewDelegate
@available(iOS 11.0, *)
extension JobFinderViewController: SceneLocationViewDelegate {
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        print("add scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
    }
    
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        print("remove scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
    }
    
    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
    }
    
    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {
        
    }
    
    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {
        
    }
}


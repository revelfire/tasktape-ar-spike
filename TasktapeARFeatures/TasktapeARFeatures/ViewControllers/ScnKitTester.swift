//
//  ScnKitTester.swift
//  TaskTape AR Features
//
//  Created by Chris Mathias on 8/18/18.
//  Copyright © 2018 SolipsAR. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit
import ARCL
import CoreLocation

class ScnKitTester : UIViewController {
    
    @IBOutlet var sceneView: SCNView! {
        willSet {
            newValue.allowsCameraControl = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.backgroundColor = UIColor.black
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        addCamera()
        
//        renderIndicons()
        
        renderArrow()
//        let boxGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.01)
//
//        let boxNode = SCNNode(geometry: boxGeometry)
//        scene.rootNode.addChildNode(boxNode)
//
        
        
        
        
//        self.view = sceneView
//        view.addSubview(sceneView)
    }
    
    func addCamera() {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 5)
        sceneView.scene?.rootNode.addChildNode(cameraNode)
    }
//
    func renderArrow() {
        let arrowPath = UIBezierPath.arrow(from: CGPoint(x: 0, y:0), to: CGPoint(x: 0, y: 4), tailWidth: 1, headWidth: 3, headLength: 2)

        let arrowShape = SCNShape(path: arrowPath, extrusionDepth: CGFloat(0.2))
        arrowShape.firstMaterial?.diffuse.contents = UIColor.blue

        let arrowNode = SCNNode(geometry: arrowShape)

        sceneView.scene?.rootNode.addChildNode(arrowNode)
    }

//    func renderIndicons() {
//        //Load TT data for Jobs
//
//        //Point jobs out in view with "job icon"
//
//        //Load TT data for Areas
//
//        //Point areas out in view with "tapes icon"
//
//
//        for jobData in JobData.jobs {
//
//            //This only works when we captured geo data. (AR mode was on)
//            if let lat = jobData.address?.geolocation?.lat, lat > 0 {
//
//                let jobViewNode = renderIndicon(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees((jobData.address?.geolocation?.lng)!), altitude: 149, imageName: "tapeLargeIcon")
//
//                jobViewNode.annotationNode.addChildNode(createLabel(jobData: jobData, location: jobViewNode.location))
//
////                sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: jobViewNode)
//                sceneView.scene?.rootNode.addChildNode(jobViewNode)
//
//            }
//
//        }
//    }
//
//    private func createLabel(jobData:JobData.Job, location: CLLocation) -> SCNNode {
//
//        let skScene = SKScene(size: CGSize(width: 350, height: 350))
//        skScene.backgroundColor = UIColor.white
////        skScene.view?.layer.cornerRadius = 10
////        skScene.view?.clipsToBounds = true
//
//        let rectangle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 350, height: 350), cornerRadius: 10)
//        rectangle.fillColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
//        rectangle.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        rectangle.lineWidth = 2
//        rectangle.alpha = 0.8
//
//        skScene.addChild(rectangle)
//
//        let textSurround = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 350*UIScreen.main.scale, height: 170))
////        textSurround.
////        textSurround.fillColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
////        textSurround.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
////        textSurround.lineWidth = 1
////        textSurround.alpha = 1
//
//        let fontSize = 40
//        let fontName = "Avenir-Light"
//
//        skScene.addChild(textSurround)
//
//        //        instructionLabelNode.position = CGPoint(x:0,y:0)
//
//        //Create a spritekit label for the data (todo: DistanceFrom)
//        let jobNameLabel = SKLabelNode(fontNamed: fontName)  //TODO: This needs to be multi-line capable
//        jobNameLabel.text = jobData.name
//        jobNameLabel.fontSize = CGFloat(fontSize)
//        jobNameLabel.fontColor = UIColor.white
//        jobNameLabel.position = CGPoint( x: 5 , y: 45 )
//        jobNameLabel.horizontalAlignmentMode = .left
//        jobNameLabel.alpha = 1
//        //Add label to the spritekit scene
//
////        jobNameLabel.addChild(textSurround)
//
//        textSurround.addChild(jobNameLabel)
//
//
////        if let userLocation = userLocation{ //sceneLocationView.currentLocation() {
//            //Add distance to job
//            let distanceLabel = SKLabelNode(fontNamed: fontName)
//            let distanceToSite = 100.0 //location.distance(from: userLocation).rounded()
//            let distanceInMiles = (distanceToSite * 0.000621371).rounded()
//            distanceLabel.text = "Distance: \(distanceInMiles) miles"
//            distanceLabel.fontSize = CGFloat(fontSize)
//            distanceLabel.fontColor = UIColor.white
//
//            distanceLabel.position = CGPoint( x: 5 , y: 5 )
//            distanceLabel.horizontalAlignmentMode = .left
//            //Add label to the spritekit scene
//            skScene.addChild(distanceLabel)
//
////        }
//
//        do {
//            if let jobImage = jobData.jobImage, let contentUrl = jobImage.contentUrl {
//                let url = URL(string: contentUrl)
//
//                let data = try Data(contentsOf: url! as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
//                let theImage = UIImage(data: data)!.resizeImage(CGFloat(550), opaque: false)
//
//                let texture = SKTexture(image: theImage)
//                let jobImageSprite = SKSpriteNode(texture: texture)
//
//                //Find center of image and use that
//                let centerX = jobImageSprite.frame.width / 2
//                let centerY = (jobImageSprite.frame.height / 2)
//                jobImageSprite.position = CGPoint( x: centerX, y:centerY)//  theImage.topCapHeight / 2  )
//                jobImageSprite.alpha = 0.6
//
//                skScene.addChild(jobImageSprite)
//            }
//        } catch let error as NSError {
//            // error
//            print("Error loading job image: \(error)")
//        }
//
//        //TODO: Add job image if we can...external url :/
//
//        //Add the spritekit scene to a scenekit plane
//        let plane = SCNPlane(width: 1.5, height: 1.5)
//        let material = SCNMaterial()
//        material.isDoubleSided = true
//        material.diffuse.contents = skScene
//        //Flip to face forward
//        material.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
//        plane.materials = [material]
//
//        let currentJobViewNode = SCNNode(geometry: plane)
//
//        currentJobViewNode.position = SCNVector3Make(currentJobViewNode.position.x, currentJobViewNode.position.y - 0.75, currentJobViewNode.position.z)
//        return currentJobViewNode
//
//    }
//
//    func renderIndicon(latitude: CLLocationDegrees, longitude: CLLocationDegrees, altitude: CLLocationDistance, imageName: String) -> LocationAnnotationNode {
//
//        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let location = CLLocation(coordinate: coordinate, altitude: altitude)
//
//        let imageAsDataSoWeCanScaleIt = UIImagePNGRepresentation(UIImage(named: imageName)!)
//        let image = UIImage(data: imageAsDataSoWeCanScaleIt!, scale: CGFloat(3))!
//        return LocationAnnotationNode(location: location, image: image)
//    }
//
//    @objc func updateInfoLabel() {
////        if let position = sceneView.currentScenePosition() {
////            infoLabel.text = "x: \(String(format: "%.2f", position.x)), y: \(String(format: "%.2f", position.y)), z: \(String(format: "%.2f", position.z))\n"
////        }
//
////        if let eulerAngles = sceneLocationView.currentEulerAngles() {
////            infoLabel.text!.append("Euler x: \(String(format: "%.2f", eulerAngles.x)), y: \(String(format: "%.2f", eulerAngles.y)), z: \(String(format: "%.2f", eulerAngles.z))\n")
////        }
//
//        //        if let heading = sceneLocationView.locationManager.heading,
//        //            let accuracy = sceneLocationView.locationManager.headingAccuracy {
//        //            infoLabel.text!.append("Heading: \(heading)º, accuracy: \(Int(round(accuracy)))º\n")
//        //        }
//
//        let date = Date()
//        let comp = Calendar.current.dateComponents([.hour, .minute, .second, .nanosecond], from: date)
//
////        if let hour = comp.hour, let minute = comp.minute, let second = comp.second, let nanosecond = comp.nanosecond {
////            infoLabel.text!.append("\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", second)):\(String(format: "%03d", nanosecond / 1000000))")
////        }
//    }
}

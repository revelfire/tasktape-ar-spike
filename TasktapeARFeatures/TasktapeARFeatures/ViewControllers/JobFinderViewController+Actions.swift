import UIKit
import SceneKit

extension JobFinderViewController: UIGestureRecognizerDelegate {    
    
    /// - Tag: restartExperience
    func restartExperience() {
        guard isRestartAvailable else { return }
        isRestartAvailable = false

        statusViewController.cancelAllScheduledMessages()

        resetTracking()
        
        //TODO: Reset tagged areas

        // Disable restart for a while in order to give the session time to restart.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isRestartAvailable = true
        }
    }
    
    ///- MARK: Tapped Indicon
    @objc func handleTap(sender:UITapGestureRecognizer) {
        print("Tapped the sceneview")
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        
        if (hitTest.isEmpty) {
            print("Didn't touch anything")
        } else {
            let results = hitTest.first!
            self.askForDispositioning(foundNode: results.node)
        }
    }
    
    func askForDispositioning(foundNode: SCNNode) {
        
        guard let tappedJob = JobData.getJob(foundNode.name!) else { return }
        
        print("you tapped \(tappedJob.name!)")
        
        messageBox(
            messageTitle: "Looking at \(tappedJob.name!). Do you want to...",
            messageAlert: tappedJob.name!,
            messageBoxStyle: .actionSheet,
            alertActionStyle: .default)
    }
    
    func messageBox(messageTitle: String, messageAlert: String, messageBoxStyle: UIAlertControllerStyle, alertActionStyle: UIAlertActionStyle)
    {
        let alert = UIAlertController(title: messageTitle, message: messageAlert, preferredStyle: messageBoxStyle)
        
        let jobDetailAction = UIAlertAction(title: "Open Job Details", style: alertActionStyle) { _ in
            print("Opening in job details UI")
        }
        
        alert.addAction(jobDetailAction)
        
        let mapsAction = UIAlertAction(title: "Open in Maps", style: alertActionStyle) { _ in
            print("Opening maps with job address")
        }
        
        alert.addAction(mapsAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}


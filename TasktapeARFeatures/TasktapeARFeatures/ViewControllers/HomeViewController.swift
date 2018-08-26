//
//  ViewController.swift
//  TaskTape AR Features
//
//  Created by Chris Mathias on 7/15/18.
//  Copyright © 2018 SolipsAR. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {    
    
    @IBAction func marshallJobFinderViewController(_ sender: Any) {
        let jobFinderVC = JobFinderViewController.storyboardInstance()
        print(jobFinderVC)
        self.present(jobFinderVC, animated: true)
    }
    
    @IBAction func marshallAreaHeadingViewController(_ sender: Any) {
        let areaHeadingVC = AreaHeadingViewController.storyboardInstance()
        print(areaHeadingVC)
        self.present(areaHeadingVC, animated: true)
    }

    func marshallTapeFinderViewController() {
        
    }
}

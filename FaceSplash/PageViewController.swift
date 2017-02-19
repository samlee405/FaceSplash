//
//  PageViewController.swift
//  FaceSplash
//
//  Created by Sam Lee on 2/19/17.
//  Copyright © 2017 Sam Lee. All rights reserved.
//

import Foundation
import UIKit

class PageViewController: UIPageViewController {
    
    var pages = ["EmitterVC", "CameraVC"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmitterVC")
        setViewControllers([vc!], direction: .forward, animated: true, completion: nil)
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index == 1 {
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[0])
                }
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index == 0 {
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[1])
                }
            }
        }
        
        return nil
    }
    
}

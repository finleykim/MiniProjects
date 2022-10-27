//
//  ViewController.swift
//  ScrollMoving
//
//  Created by finley on 2022/10/24.
//

import UIKit


 
    class ViewController: UIViewController, UIScrollViewDelegate {
        @IBOutlet weak var myView: UIImageView!
        @IBOutlet weak var scrollView: UIScrollView!
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view = scrollView

            scrollView.delegate = self
            scrollView.maximumZoomScale = 3.0
            scrollView.minimumZoomScale = 1
            scrollView.bouncesZoom = true
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.addSubview(myView)
            scrollView.backgroundColor = .systemBlue

        }
        
              func viewForZooming(in scrollView: UIScrollView) -> UIView? {
                return myView
              }
        
    }




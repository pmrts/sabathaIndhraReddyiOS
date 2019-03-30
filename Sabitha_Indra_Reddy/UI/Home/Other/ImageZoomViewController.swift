//
//  ImageZoomViewController.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 11/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class ImageZoomViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var showImageView: UIImageView?
    
    var ImageURL : String?
    var panGestureRecognizer: UIPanGestureRecognizer?
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    var doubleTap : UITapGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        showImageView?.imageFromServerURL(urlString: ImageURL!)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
        self.view.addGestureRecognizer(panGestureRecognizer!)
        
        doubleTap = UITapGestureRecognizer (target: self, action: #selector(doubletapImageView))
        doubleTap?.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap!)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.showImageView
    }
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let touchPoint = panGesture.location(in: self.view?.window)
        
        if panGesture.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if panGesture.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if panGesture.state == UIGestureRecognizer.State.ended || panGesture.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    
    @objc func doubletapImageView() {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale((scrollView?.minimumZoomScale)!, animated: true)
        }
        else {
            scrollView.setZoomScale((scrollView?.maximumZoomScale)!, animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

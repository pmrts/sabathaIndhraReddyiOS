//
//  MainViewController.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 19/05/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var pageControl : UIPageControl?
    var totalPages = 0
    @IBOutlet var pageBarButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPageViewController" {
            
            let pageVC = segue.destination as? InitialPageViewController
            pageVC?.updatePageControl = { page in
                self.pageControl?.currentPage = page
                self.pageBarButton?.title = "\(page + 1) / \(self.totalPages)"
                
                // Done BUtton Logic 
                
            }
            pageVC?.numberOfPages = { total in
                self.pageControl?.numberOfPages = total
                self.totalPages = total
                self.pageBarButton?.title = "\(1) / \(self.totalPages)"
            }
        }
    }
    

}

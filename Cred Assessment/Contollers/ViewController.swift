//
//  ViewController.swift
//  CRED Assessment
//
//  Created by Rohan Dalmotra on 26/07/22.
//


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.animate()
        })
    }
    
    func animate(){
        UIImageView.animate(withDuration: 0.75, animations: {
            self.logoImage.frame.origin.y = self.view.frame.maxY
        })
        
        UIImageView.animate(withDuration: 1, animations: {
            self.logoImage.alpha = 0
        }, completion: { done in
            self.performSegue(withIdentifier: "ToMainVC", sender: self)
        })
    }
    
}

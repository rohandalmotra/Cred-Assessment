//
//  MainViewController.swift
//  CRED Assessment
//
//  Created by Rohan Dalmotra on 26/07/22.
//

import UIKit
class MainViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var pointerLabel: UILabel!
    @IBOutlet weak var credImage: UIImageView!
    @IBOutlet weak var circleImage: UIImageView!
    
    var brain = Brain()
    override func viewDidLoad() {
        super.viewDidLoad()
        brain.delegate = self
        dimensions()
        setupPanRecognizer()
        setPointerFlashing()
    }
    
    //MARK:- Making ImageView Movable
    func setupPanRecognizer(){
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        credImage.isUserInteractionEnabled = true
        credImage.addGestureRecognizer(panRecognizer)
    }
    
    
    @objc func handlePan(panGesture: UIPanGestureRecognizer){
        let translation = panGesture.translation(in: view)
        panGesture.setTranslation(.zero, in: view)
        credImage.center.y = credImage.center.y + translation.y
        
        if panGesture.state == .ended{
            detectCircleReached()
        }
        func detectCircleReached(){
            if credImage.frame.intersects(circleImage.frame){
                credImage.center = circleImage.center
                brain.success()
                pointerLabel.stopBlink()
                pointerLabel.text = ConstantValue.emptyString
                circleImage.tintColor = .white
                
                
                
            }
            else{
                credImage.center.y = CGFloat(ConstantValue.credImageCenterY)
                brain.failure()
                textLabel.text = ConstantValue.emptyString
                circleImage.tintColor = UIColor(named: ConstantValue.circleColor)
            }
            //            print(credImage.center)
        }
    }
    
    //MARK:- All Dimension Work
    
    func setPointerFlashing(){
        pointerLabel.text = ConstantValue.pointerLabelText
        pointerLabel.startBlink()
    }
    
    
    func dimensions(){
        textLabel.text = ConstantValue.emptyString
        upperView.layer.cornerRadius = CGFloat(ConstantValue.upperViewCornerRadius)
        upperView.layer.masksToBounds = true
        credImage.layer.cornerRadius = credImage.frame.size.height/2
        credImage.layer.masksToBounds = false
        credImage.clipsToBounds = true
    }
}

//MARK: - BrainDelegate

extension MainViewController: BrainDelegate{
    func didGetSuccess(status: Bool) {
        DispatchQueue.main.async {
            if status{
                self.textLabel.text = ConstantValue.textLabelText
                self.credImage.isHidden = true
                self.circleImage.isHidden = true
                
            }
            else{
                print(ConstantValue.errorDisplayedAtFalse)
            }
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

//MARK: - UILabel Blinking Effect

extension UILabel {
    
    func startBlink() {
        UIView.animate(withDuration: 0.2,
                       delay:0.0,
                       options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
                       animations: { self.alpha = 0 },
                       completion: nil)
    }
    
    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}

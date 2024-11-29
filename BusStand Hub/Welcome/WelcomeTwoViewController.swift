//
//  WelcomeTwoViewController.swift
//  NameSpectrum Hub
//
//  Created by Maaz on 03/10/2024.
//

import UIKit

class WelcomeTwoViewController: UIViewController {
    @IBOutlet weak var VurveView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addBottomCurveforView(view: VurveView)
        applyGradientToButtonTwo(view: VurveView)
    }
    private func applyGradientToButtonTwo(view: UIView) {
            let gradientLayer = CAGradientLayer()
            
            // Define your gradient colors
            gradientLayer.colors = [
                UIColor(hex: "#3cc5f8").cgColor, // Purple
                UIColor(hex: "#3cc5f8").cgColor, // Bright Purple
                UIColor(hex: "#6e64e6").cgColor, // Violet
                UIColor(hex: "#8830dd").cgColor
            ]
            
            // Set the gradient direction
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)   // Top-left
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)     // Bottom-right
            
            // Set the gradient's frame to match the button's bounds
            gradientLayer.frame = view.bounds
            
            // Apply rounded corners to the gradient
            gradientLayer.cornerRadius = view.layer.cornerRadius
            
            // Add the gradient to the button
        view.layer.insertSublayer(gradientLayer, at: 0)
        }
    @IBAction func nextButton(_ sender: Any) {
        
               let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let newViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeThreeViewController") as! WelcomeThreeViewController
               newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
               newViewController.modalTransitionStyle = .crossDissolve
               self.present(newViewController, animated: true, completion: nil)
    }

    @IBAction func previousButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}

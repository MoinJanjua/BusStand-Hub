//
//  WelcomeOneViewController.swift
//  NameSpectrum Hub
//
//  Created by Maaz on 03/10/2024.
//

import UIKit

class WelcomeOneViewController: UIViewController {

    @IBOutlet weak var VurveView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBottomCurveforView(view: VurveView)
        applyGradientToButton(view: VurveView)


    }
    

    @IBAction func nextButton(_ sender: Any) {
        
               let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let newViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeTwoViewController") as! WelcomeTwoViewController
               newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
               newViewController.modalTransitionStyle = .crossDissolve
               self.present(newViewController, animated: true, completion: nil)
    }

}

//
//  ScoreViewController.swift
//  DemoApp
//  Created by Pramit on 18/11/19.

import UIKit

class ScoreViewController: UIViewController {

    @IBOutlet weak var viewFullScreen: UIView!
    @IBOutlet var viewPopup: UIView!
    var strTotal = ""
  
    @IBOutlet weak var lblTotalScore: UILabel!
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        self.lblTotalScore.text = "\(strTotal) / 10"
        self.initialiseViewController()

    }

    //MARK: INITIALISE VIEW CONTROLLER
    func initialiseViewController(){
        
        viewPopup.center = view.center
        viewPopup.alpha = 1
        viewPopup.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)

        self.view.addSubview(viewPopup)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
                self.viewPopup.transform = .identity
        })

    }
    
   //MARK: ACTION BACK EVENTS
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated:true)
    }
    

}

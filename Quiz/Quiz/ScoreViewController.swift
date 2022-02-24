////
////  ScoreViewController.swift
////  Quiz
////
////  Created by Matiara Sianipar on 11/20/21.
////
//
import UIKit


class ScoreViewController: UIViewController {
    
    @IBOutlet var scoreLabel: UILabel!
    
    let AbsoluteTotal = String(9)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scoreLabel.text = String(Score.sharedInstance.score) + " / " + String(Score.sharedInstance.total)
        
        if Score.sharedInstance.score > Score.sharedInstance.incorrects {
            self.view.backgroundColor = UIColor.green
        }
        
        if Score.sharedInstance.score < Score.sharedInstance.incorrects {
            self.view.backgroundColor = UIColor.red
        }
        
        if Score.sharedInstance.score == Score.sharedInstance.incorrects {
            self.view.backgroundColor = UIColor.white
        }
        
        
//        func updateScoreLabel() {
//            if let Score.sharedInstance.score = Score.sharedInstance.score {
//                scoreLabel.text = String(Score.sharedInstance.score) + " / " + String(Score.sharedInstance.total)
//            }
//            else {
//                scoreLabel.text = "???"
//            }
//        }
        
    }
        
//    @IBAction func scoreEditingChanged(_)
}

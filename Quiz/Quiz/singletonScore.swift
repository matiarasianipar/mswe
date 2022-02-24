//
//  singletonScore.swift
//  Quiz
//
//  Created by Matiara Sianipar on 11/25/21.
//

import Foundation

class Score {
    static let sharedInstance = Score()
    var score = Int()
    var incorrects = Int()
//    {
//        didSet {
//            ScoreViewController.updateScoreLabel()
//        }
//    }
    var total = Int()
    
    func addScore() {
        score += 1
    }
    
    func wrong() {
        incorrects += 1
    }
        
    func addTotal() {
        total += 1
    }
        
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        updateScoreLabel()
//    }
    
}

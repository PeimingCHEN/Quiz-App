//
//  ScoreViewController.swift
//  Quiz
//
//  Created by Peiming Chen on 11/28/22.
//

import UIKit

class Score {
    static let sharedInstance = Score()
    var correct:Int = 0
    var incorrect:Int = 0
}

class ScoreViewController: UIViewController {
    @IBOutlet var correctLabel: UILabel!
    @IBOutlet var incorrectLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showBackgroundColor()
        correctLabel.text = "Correct: \(Score.sharedInstance.correct)"
        incorrectLabel.text = "Incorrect: \(Score.sharedInstance.incorrect)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showBackgroundColor()
        correctLabel.text = "Correct: \(Score.sharedInstance.correct)"
        incorrectLabel.text = "Incorrect: \(Score.sharedInstance.incorrect)"
    }
    
    func showBackgroundColor() {
        let correct = Score.sharedInstance.correct
        let incorrect = Score.sharedInstance.incorrect
        switch(correct) {
        case _ where correct > incorrect:
            self.view.backgroundColor = UIColor.green
        case _ where correct < incorrect:
            self.view.backgroundColor = UIColor.red
        default:
            self.view.backgroundColor = UIColor.white
        }
    }
}

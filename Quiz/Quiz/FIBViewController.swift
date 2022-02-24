//
//  FIBViewController.swift
//  Quiz
//
//  Created by Matiara Sianipar on 11/20/21.
//

import UIKit

class FIBViewController: UIViewController {
    
    @IBOutlet weak var questionLabelFIB: UILabel!
    @IBOutlet weak var nextQuestionFIB: UIButton!
    @IBOutlet weak var answerTextFieldFIB: UITextField!
    @IBOutlet weak var correctLabelFIB: UILabel!
    @IBOutlet weak var submitFIB: UIButton!
    @IBOutlet var imageViewFIB: UIImageView!
    
    var questionStore: QuestionsStore!
    var imageStore: ImageStore!
        
    @IBAction func showNextQuestion(_ sender: UIButton) {
        questionStore.currentQuestionIndex += 1
        if questionStore.currentQuestionIndex == questionStore.allQuestions.count {
            questionStore.currentQuestionIndex = 0
        }
        
        let question: String =
        questionStore.allQuestions[questionStore.currentQuestionIndex].question
        questionLabelFIB.text = question
        correctLabelFIB.text = ""
        answerTextFieldFIB.reloadInputViews()
        
        if questionStore.allQuestions[questionStore.currentQuestionIndex].answeredFIB == true {
            submitFIB.isEnabled = false
        }
        else {
            submitFIB.isEnabled = true
        }
        
        answerTextFieldFIB.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        answerTextFieldFIB.delegate = self
        if questionStore.allQuestions.count == 0 {
            questionLabelFIB.text = ""
            submitFIB.isEnabled = false
            nextQuestionFIB.isEnabled = false
        }
//        else {
//        submitFIB.addTarget(self, action: #selector(tapBtn), for: .touchUpInside)
//        questionLabelFIB.text = questionStore.allQuestions[questionStore.currentQuestionIndex].question
////        print(Score.sharedInstance.score)
////        print(Score.sharedInstance.total)
//        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if questionStore.allQuestions.count > 0 {
            questionLabelFIB.text = questionStore.allQuestions[questionStore.currentQuestionIndex].question
            submitFIB.isEnabled = !questionStore.allQuestions[questionStore.currentQuestionIndex].answeredFIB
            let key = questionStore.allQuestions[questionStore.currentQuestionIndex].questionKey
            let imageToDisplay = imageStore.image(forKey: key)
            imageViewFIB.image = imageToDisplay
            }
    }
    
    @IBAction func tapBtn (_ sender: UITextField)  {
        
        var unanswered = questionStore.allQuestions.count

        Score.sharedInstance.addTotal()
//        Score.sharedInstance.total += 1
        let userAnswer = Int(self.answerTextFieldFIB.text!)
        
        if userAnswer == questionStore.allQuestions[questionStore.currentQuestionIndex].correctAnswers {
            correctLabelFIB.textColor = UIColor.green
            correctLabelFIB.text = "CORRECT"
            Score.sharedInstance.addScore()
            questionStore.allQuestions[questionStore.currentQuestionIndex].answeredFIB = true
            unanswered -= 1
            submitFIB.isEnabled = false
        }
        if userAnswer != questionStore.allQuestions[questionStore.currentQuestionIndex].correctAnswers {
            correctLabelFIB.textColor = UIColor.red
            correctLabelFIB.text = "INCORRECT"
            Score.sharedInstance.wrong()
            questionStore.allQuestions[questionStore.currentQuestionIndex].answeredFIB = true
            unanswered -= 1
            submitFIB.isEnabled = false
        }
        
        if unanswered == 0 {
            nextQuestionFIB.isEnabled = false
        }
                    
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        answerTextFieldFIB.resignFirstResponder()
    }
    
}

//extension FIBViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Int {
//        return Int
//    }
//}

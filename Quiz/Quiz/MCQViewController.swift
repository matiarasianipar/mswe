// http://www.wepstech.com/uipickerview-in-swift/
//
//  ViewController.swift
//  Quiz
//
//  Created by Matiara Sianipar on 11/16/21.
//

import UIKit

class MCQViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var btn: UIButton!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    let questions: [String] = [
        "Which of the following is a zodiac sign?",
        "Which of the following is the Aries's ruling planet?",
        "Which of the following is not a water sign?"
    ]
    let answers = [
        ["Sagittarius", "Obsidian", "Caprisun"],
        ["Jupiter", "Mars", "Venus"],
        ["Scorpio", "Pisces", "Aquarius"]
    ]
    
    let correctAnswers = [
        0,
        1,
        2
    ]
    
    var currentQuestionIndex: Int = 0
//    var answered = false
    var answeredMCQ = [
        0,
        0,
        0
    ]
    
    
    @IBAction func showNextQuestion(_ sender:
UIButton)   {
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count {
            currentQuestionIndex = 0
        }
        
        let question: String =
    questions[currentQuestionIndex]
        questionLabel.text = question
        answerLabel.text = "???"
        pickerView.reloadAllComponents()
        correctLabel.text = ""
//        btn.reloadInputViews()
        
        if answeredMCQ[currentQuestionIndex] == 1 {
            btn.isEnabled = false
        }
        else {
            btn.isEnabled = true
        }
        
        
//        btn.isEnabled = true

//        if answered == true {
//            btn.isEnabled = false
//        }
//        else {
//            btn.isEnabled = true
//        }
    }
    
//    @IBAction func showAnswer(_ sender: UIButton)   {
//        let answer: String = answers[currentQuestionIndex]
//        answerLabel.text = answer
//    }
    
    var list: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.layer.cornerRadius = 10
        answerLabel.layer.cornerRadius = 10
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        btn.addTarget(self, action: #selector(tapBtn), for: .touchUpInside)
        questionLabel.text = questions[currentQuestionIndex]
        correctLabel.text = ""

    }
    
    @IBAction func tapBtn (_ sender: UIButton)    {
        Score.sharedInstance.addTotal()
//        Score.sharedInstance.total += 1
        answerLabel.text = answers[currentQuestionIndex][self.pickerView.selectedRow(inComponent: 0)]
        let userAnswer = self.pickerView.selectedRow(inComponent: 0)
        
        if userAnswer == correctAnswers[currentQuestionIndex] {
            correctLabel.textColor = UIColor.green
            correctLabel.text = "CORRECT"
//            answered = true
            Score.sharedInstance.addScore()
//            Score.sharedInstance.score += 1
            answeredMCQ[currentQuestionIndex] = 1
            btn.isEnabled = false
        }
        
        if userAnswer != correctAnswers[currentQuestionIndex] {
            correctLabel.textColor = UIColor.red
            correctLabel.text = "INCORRECT"
//            answered = true
            Score.sharedInstance.wrong()
            answeredMCQ[currentQuestionIndex] = 1
            btn.isEnabled = false
        }
        
        if answeredMCQ == [1, 1, 1] {
            nextBtn.isEnabled = false
        }
                
        print(userAnswer)
//        btn.isEnabled = false
                
    }
}

extension MCQViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return answers[currentQuestionIndex].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return answers[currentQuestionIndex][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        return answers[currentQuestionIndex][row]
    }
}



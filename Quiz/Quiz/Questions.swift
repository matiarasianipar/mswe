//
//  QuestionsController.swift
//  Quiz
//
//  Created by Matiara Sianipar on 11/28/21.
//

import UIKit

class Question: Equatable, Codable {
    
    var question: String
    var correctAnswers: Int
    var answeredFIB: Bool
    //    var currentQuestionIndex: Int
    var dateCreated = Date()
    //    var questionKey: String
    //    var image: UIImage?
    let questionKey: String
    
    var graph: [Line]

    init(question: String, correctAnswers: Int) {
        
        self.question = question
        self.correctAnswers = correctAnswers
        self.answeredFIB = false
//        self.currentQuestionIndex = currentQuestionIndex
        self.dateCreated = Date()
        self.questionKey = UUID().uuidString
        self.graph = []
//        self.image = nil
    }
        static func ==(lhs: Question, rhs: Question) -> Bool {
            return lhs.question == rhs.question
            && lhs.correctAnswers == rhs.correctAnswers
            && lhs.answeredFIB == rhs.answeredFIB
            && lhs.dateCreated == rhs.dateCreated
        
    }
}
 

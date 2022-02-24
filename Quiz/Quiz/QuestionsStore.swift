//
//  QuestionsStore.swift
//  Quiz
//
//  Created by Matiara Sianipar on 11/28/21.
//

import UIKit

class QuestionsStore {
    
    var allQuestions = [Question]()
    let questionsArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.plist")
    }()
    
    var currentQuestionIndex = 0

    init() {
        do {
            let data = try Data(contentsOf: questionsArchiveURL)
            let unarchiver = PropertyListDecoder()
            let items = try unarchiver.decode([Question].self, from: data)
            allQuestions = items
        } catch {
            print("Error reading in saved items: \(error)")
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    func removeQuestion(_ question: Question) {
        if let index = allQuestions.firstIndex(of: question) {
            allQuestions.remove(at: index)
        }
    }
        
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
//            get reference to object being moved so you can reinsert it
        let movedItem = allQuestions[fromIndex]
        
//            Remove question from array
        allQuestions.remove(at: fromIndex)
        
//            insert item in array at new location
        allQuestions.insert(movedItem, at: toIndex)
    }
    
    @objc func saveChanges() -> Bool {
        print("Saving items to: \(questionsArchiveURL)")

        do {
        let encoder = PropertyListEncoder()
        let data = try encoder.encode(allQuestions)
        try data.write(to: questionsArchiveURL, options: [.atomic])
        print("Saved all of the items")
        return true
        }
        catch let encodingError {
            print("Error encoding allQuestions: \(encodingError)")
        return false
    }
}

}

//
//  QuestionsViewController.swift
//  Quiz
//
//  Created by Matiara Sianipar on 11/28/21.
//

import UIKit

class QuestionsViewController: UITableViewController {
    
    @IBOutlet weak var questionsView: UITableView!
    
    var questionStore: QuestionsStore!
    var imageStore: ImageStore!
    
//    var questionsStore: QuestionsStore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionStore.allQuestions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath)
        cell.textLabel?.text = questionStore.allQuestions[indexPath.item].question
        cell.detailTextLabel?.text = String(questionStore.allQuestions[indexPath.item].correctAnswers)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {        questionStore.moveItem(from:sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        If table view is asking to commit delte command...
        if editingStyle == .delete {
            let item = questionStore.allQuestions[indexPath.row]
            
//            remove item from store
            questionStore.removeQuestion(item)
            
            print(indexPath.row)
            
//            remove item's image from image store
            imageStore.deleteImage(forKey: item.questionKey)
            
//            remove table view with animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showQuestion":
//            figure out which row was tapped
            if let row = tableView.indexPathForSelectedRow?.row {
//                get item associated with row and pass it along
                let question = questionStore.allQuestions[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.row = row
                detailViewController.question = question
                detailViewController.imageStore = imageStore
            }
        case "add":
            let detailViewController = segue.destination as! DetailViewController
            let blankQuestion = Question(question: "", correctAnswers: 0)
            questionStore.allQuestions.append(blankQuestion)
            detailViewController.row = -1
            detailViewController.question = blankQuestion
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == .delete) {
//            Questions.deleteQuestion(indexPath.item)
//        }
//    }
    
//    @IBAction func addNewQuestion(_ sender: UIButton) {
////        create new item and add to store
////        figure out what item is in array
//        if let index = questionStore.allQuestions.firstIndex(of: newQuestion) {
//            let indexPath = IndexPath(row: index, section: 0)
//
////            insert new row into table
//            tableView.insertRows(at: [indexPath], with: .automatic)
//        }
        
        
//    }
    
    
    @IBAction func toggleEditingMode(_ sender: UIBarButtonItem) {
//        if you are currently in editing mode
        if isEditing {
//            change text of button to inform user of state
//            sender.setTitle("Edit", for: .normal)
            
//            turn off editing mode
            questionsView.reloadData()
            setEditing(false, animated: true)
        } else {
//            change text of button to inform user of state
//            sender.setTitle("Reset", for: .normal)
            
//            enter editing mode
            setEditing(true, animated: true)
        }
    }

    
//    @IBAction func editAction(_ sender: UIBarButtonItem) {
//        self.tableView.isEditing = !self.tableView.isEditing
//        sender.title = (self.tableView.isEditing) ? "Done" : "Edit"
//}
}

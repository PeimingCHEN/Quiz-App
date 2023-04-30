//
//  NumTableViewController.swift
//  Quiz
//
//  Created by Peiming Chen on 11/29/22.
//

import UIKit

class NumTableViewController: UITableViewController {
        
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        // reset score
        Score.sharedInstance.correct = 0
        Score.sharedInstance.incorrect = 0
        // reset number question answer
        let tabbar = tabBarController as! BaseTabBarController
        for question in tabbar.QuestionStore.allQuestions {
            question.useranswer = nil
        }
        // reset NUM view controller
        let NUMVC = self.tabBarController?.viewControllers?[1] as! NumViewController
        if NUMVC.showed {
            NUMVC.updateview()
        }
        // reset MCQ answer and submit count and index
        let MCQVC = self.tabBarController?.viewControllers?[0] as! MCQViewController
        MCQVC.updateview()
        // reload cell data
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tabbar = tabBarController as! BaseTabBarController
        return tabbar.QuestionStore.allQuestions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "NumQuestionCell", for: indexPath) as! NumQuestionCell
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n=row this cell
        // will appear in on the table view
        let tabbar = tabBarController as! BaseTabBarController
        let question = tabbar.QuestionStore.allQuestions[indexPath.row]
        
        cell.questionLabel.text = question.question
        if question.useranswer == nil {
            cell.useranswerLabel.text = "your answer: -"
            cell.answerLabel.text = "correct answer: -"
            cell.useranswerLabel.textColor = UIColor.black
        } else {
            cell.useranswerLabel.text = "your answer: \(question.useranswer!)"
            cell.answerLabel.text = "correct answer: \(question.answer)"
            if question.useranswer! == question.answer {
                cell.useranswerLabel.textColor = UIColor.green
            } else {
                cell.useranswerLabel.textColor = UIColor.red
            }
        }
        
        return cell
    }
    
    // delete question
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let tabbar = tabBarController as! BaseTabBarController
        
        // If the table view is asking to commit a delete command
        if editingStyle == .delete {
            let question = tabbar.QuestionStore.allQuestions[indexPath.row]
            
            // Remove the item from the store
            tabbar.QuestionStore.removeQuestion(question)
            
            // Remove the item's image from the image store
            tabbar.imageStore.deleteImage(forKey: question.imageKey)
            
            // Also remove that row from the table view with an animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // move question
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        let tabbar = tabBarController as! BaseTabBarController
        
        tabbar.QuestionStore.moveQuestion(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showItem":
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the item associated with this row and pass it along
                let tabbar = tabBarController as! BaseTabBarController
                let item = tabbar.QuestionStore.allQuestions[row]
                let imageStore = tabbar.imageStore
                let detailViewController
                        = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
        }
        case "addItem":
            let tabbar = tabBarController as! BaseTabBarController
            let item = tabbar.QuestionStore.createQuestion()
            let imageStore = tabbar.imageStore
            let detailViewController
                    = segue.destination as! DetailViewController
            detailViewController.item = item
            detailViewController.imageStore = imageStore
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    // set the left bar button item
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        navigationItem.leftBarButtonItem = editButtonItem
    }
}

//
//  QuestionAnswersTVC.swift
//  PAL
//
//  Created by admin on 7/10/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit
import SwiftyJSON

class QuestionAnswersTVC: UITableViewController {

    var questions: [Post] = [Post]()
    var answers: [Post] = [Post]()
    var answer: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submission_id = UserDefaults.standard.integer(forKey: "submission_id")
        self.getQuestionWithAnswer()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count;
    }
    
    func getQuestionWithAnswer() {
        Service().getFormBySubmission(submission_id: submission_id!){ (response) in
            
            
            for(_, responseJSON):(String, JSON) in response {
                
                let qLabel = Post(question: responseJSON["question"].stringValue)
                self.questions.append(qLabel)
                
                let aLabel = Post(answer: responseJSON["answer"].stringValue)
                self.answers.append(aLabel)
            }
            
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let submittedQA = self.tableView.dequeueReusableCell(withIdentifier: "QACell", for: indexPath) as! DisplayAnswersCell
        
        let firstLabel = self.questions[indexPath.row]
        let secondLabel = self.answers[indexPath.row]
        
        if secondLabel.answer! == "2" {
            answer = "Strongly Agree"
        } else if secondLabel.answer! == "1" {
            answer = "Agree"
        } else if secondLabel.answer! == "0" {
            answer = "Not Sure"
        } else if secondLabel.answer! == "-1" {
            answer = "Disagree"
        } else if secondLabel.answer! == "-2" {
            answer = "Strongly Disagree"
        }
        
        
        submittedQA.questionLabel.text = firstLabel.question!
        submittedQA.answerLabel.text = answer
        
        return submittedQA
    }
    

}

//
//  QuestionsTVC.swift
//  PAL
//
//  Created by admin on 6/20/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit
import SwiftyJSON

class QuestionsTVC: UITableViewController {

    //Variable to hold questions
    var questions: [Post] = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getQuestions()
    }
    
    func getQuestions() {
        //CHANGE THE FORM ID WHEN THE COUNSELOR IS MADE !!!!!!!!!!
        Service().getFormByID(form_id: 23) { (response) in
            for(_, responseJSON):(String, JSON) in response {
                let question = Post(question: responseJSON["question"].stringValue)
                self.questions.append(question)
            }
            self.tableView.reloadData()
        }
    }
    
    // Submission ID - 4

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return questions.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let question = self.tableView.dequeueReusableCell(withIdentifier: "question", for: indexPath) as! QuestionsCell
        
        let post = self.questions[indexPath.row]
        
        question.questionLabel.text = post.question
        
        return question
    }
}

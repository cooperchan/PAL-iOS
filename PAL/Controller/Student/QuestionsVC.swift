//
//  QuestionsVC.swift
//  PAL
//
//  Created by admin on 6/25/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import UIKit
import SwiftyJSON
import DLRadioButton

/*
 This is the controller for the Questions for the form the user selected in QuestionsTVC
 It displays the array of questions and gives them 5 possible answers to choose from
 */
class QuestionsVC: UIViewController {

    //MARK: Variables
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var qCount: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var strongA: DLRadioButton!
    @IBOutlet weak var a: DLRadioButton!
    @IBOutlet weak var notS: DLRadioButton!
    @IBOutlet weak var d: DLRadioButton!
    @IBOutlet weak var strongD: DLRadioButton!
    
    
    var studentQuestions: [Post] = [Post]()
    var studentQuestionIDs: [Post] = [Post]()
    var counter: Int = -1
    var answer: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        user_id = UserDefaults.standard.integer(forKey: "user_id")
        submission_id = UserDefaults.standard.integer(forKey: "submission_id")
        
        self.getQuestions(count: counter)
        
        //Log Out Prompt
        let rightBarButton = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logOut))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    /*
    Gets questions based on submission id and stores in an array
    If the array is empty, show that there are no questions in form
    Otherwise show the question based on the count
    */
    func getQuestions(count: Int) {
        Service().getFormBySubmission(submission_id: submission_id!) { (response) in
            if count == -1 {
                for(_, responseJSON):(String, JSON) in response {
                    let question = Post(question: responseJSON["question"].stringValue)
                    self.studentQuestions.append(question)
                   
                    let questionID = Post(questionID: responseJSON["id"].intValue)
                    self.studentQuestionIDs.append(questionID)
                    
                }
                self.counter = 0
                self.getQuestions(count: self.counter)
            } else if self.studentQuestions.count == 0 {
                self.questionLabel.text = "There are no questions in this form"
            } else if count > -1 && count <= self.studentQuestions.count {
                print("This is count: \(count)")
                self.qCount.text = "Question \(count + 1) out of \(self.studentQuestions.count) questions"
                let quest = self.studentQuestions[count]
                self.questionLabel.text = quest.question!
            }
        }
    }
    
    //Saves the answers in an array and sends it to server
    //Also prints the amount of questions
    func submitAnswer(answer: Int) {
        let parameter: [String: Int] = ["answer": answer]
        let question_id = self.studentQuestionIDs[counter]
        print("The number of questions is: \(self.studentQuestions.count)")
        Service().submitAnswer(question_id: question_id.questionID, submission_id: submission_id!, parameters: parameter) { (response) in
            print(response)
        }
    }
    
    //At the end of the form, allows user to submit the form and sends it to server
    func submitForm() {
        Service().submitForm(submission_id: submission_id!) { (response) in
            print(response)
        }
    }

    //5 Answer Option Buttons
    @IBAction func strongAgreeButt(_ sender: Any) {
        answer = 2
    }
    
    @IBAction func agreeButt(_ sender: Any) {
        answer = 1
    }
    
    @IBAction func notSureButt(_ sender: Any) {
        answer = 0
    }
    
    @IBAction func disagreeButt(_ sender: Any) {
        answer = -1
    }
    
    @IBAction func strongDisagreeButt(_ sender: Any) {
        answer = -2
    }
    
    //WHen submit button is hit, change question and save the answer they chose
    //If the question was last in array, change to Submit Form
    //Also ensure than an answer cannot be left blank
    @IBAction func submitQuestion(_ sender: Any) {
        if self.counter < self.studentQuestions.count - 1 && answer != nil {
            //If you still have questions to answer, show next question and record answer
            self.counter += 1
            getQuestions(count: self.counter)
            submitAnswer(answer: answer!)
            print("The current counter is: \(self.counter)")
            
            //Deselect the Button and set answer to nil
            self.strongA.isSelected = false
            self.a.isSelected = false
            self.notS.isSelected = false
            self.d.isSelected = false
            self.strongD.isSelected = false
            answer = nil

        } else if self.counter == self.studentQuestions.count - 1 {
            //Else change button to submit form
            button.setTitle("Submit Form", for: .normal)
            button.backgroundColor = UIColor.red
            self.counter += 1
        } else if self.counter > self.studentQuestions.count - 1{
            //Submit form, display message, and go back to main screen
            submitForm()
            
            _ = SweetAlert().showAlert("Thank You", subTitle: "Your form has been submitted! ", style: .success)

            self.performSegue(withIdentifier: "formToTable", sender: nil)
        } else {
            _ = SweetAlert().showAlert("Error", subTitle: "Answer cannot be left blank", style: .error)
        }
        
    }
    
    /*
     Allows the user to logout, sending them back to inital landing page
     THe checker ensures that the About Info doesn't popup again
     Also closes connection to chatroom
     */
    @objc func logOut() {
        checker = true
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "homepage_nav") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
        
        StudentChatRoomVC.sharedInstance.closeConnection()
    }
    
}

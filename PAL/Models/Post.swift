//
//  Post.swift
//  PAL
//
//  Created by admin on 6/14/18.
//  Copyright © 2018 NJCU. All rights reserved.
//

import Foundation

class Post{
    
    var form: String!
    var question: String!
    var answer: String!
    var student: String!
    var studentID: Int!
    var questionID: Int!
    var submissionID: Int!
    var counselorID: Int!
    
    //Assigns created variables
    init(form: String) {
        self.form = form
    }
    
    init(question: String) {
        self.question = question
    }
    
    init(answer: String) {
        self.answer = answer
    }
    
    init(questionID: Int) {
        self.questionID = questionID
    }
    
    init(submissionID: Int) {
        self.submissionID = submissionID
    }
    
    init(student: String){
        self.student = student
    }
    
    init(studentID: Int){
        self.studentID = studentID
    }
    
    init(counselorID: Int){
        self.counselorID = counselorID
    }
}

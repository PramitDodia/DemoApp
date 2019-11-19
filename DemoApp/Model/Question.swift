//
//  Question.swift
//  DemoApp
//  Created by Pramit on 18/11/19.


import UIKit

struct Question: Codable {

    var category           : String?
    var question           : String?
    var type               : String?
    var difficulty         : String?
    var correct_answer     : String?
    var incorrect_answers  : [String]?
}


struct QuestionResponse : Codable {
    var response_code   : Int?
    var results         : [Question]?
}

//  QuizViewController.swift
//  DemoApp
//  Created by Pramit on 18/11/19.

import UIKit
import SVProgressHUD
import Alamofire

class QuizViewController: UIViewController {
    
//MARK:- ########## VARIABLES ############

    var strURL = "https://opentdb.com/api.php?amount=10"
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblQuestionTitle: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var tblQuestion: UITableView!
    @IBOutlet weak var btnNext: UIButton!
    
    var arrQuestions = [Question]()
    var currentQuestion = 0
    var arrOptions = [String]()
    var nScore = 0
    var selectedAnswerIndex = -1
    
//MARK:- ########## VIEW DELEGATES ############

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.fetchQuestions()
    }

    private func setupUI(){
        self.viewContainer.layer.cornerRadius = 5.0
    }
    
//MARK:- ########## FETCH QUESTIONS ############

    private func fetchQuestions(){
        self.showLoader()
        
        Alamofire.request(URL.init(string: self.strURL)!).responseData { response in
            switch response.result {
                case .success:
                    self.handleResponseData(responseData: response.data)
                case let .failure(error):
                    print(error)
            }
            self.hideLoader()
        }
    }
    
    private func handleResponseData(responseData: Data?){
        if let responseData = responseData{
            do{
                let responseObj = try JSONDecoder().decode(QuestionResponse.self, from: responseData)
                if let arrResults = responseObj.results{
                    self.arrQuestions = arrResults
                    self.handleQuestionUI()
                }
            }catch{
                print("Exception: \(error.localizedDescription)")
            }
        }
    }
    
    private func handleQuestionUI(){
        
        if self.currentQuestion >= self.arrQuestions.count {
            print("Final Score : \(self.nScore)")
            
            let objScoreVC = self.storyboard?.instantiateViewController(withIdentifier:"ScoreViewController") as! ScoreViewController
            objScoreVC.strTotal = "\(self.nScore)"
            self.navigationController?.pushViewController(objScoreVC, animated: true)
            return
        }
        
        let questionObj = self.arrQuestions[self.currentQuestion]
        
        self.lblQuestionTitle.text = "Question \(self.currentQuestion + 1)"
        self.lblQuestion.text = questionObj.question
        self.arrOptions.removeAll()
        
        if questionObj.type == "boolean"{
            self.arrOptions.append("True")
            self.arrOptions.append("False")

        }else{
            
            if let incorrectAnswers = questionObj.incorrect_answers{
                    self.arrOptions.append(contentsOf: incorrectAnswers)
                    self.arrOptions.append(questionObj.correct_answer ?? "")
            }
        }

        self.tblQuestion.reloadData()
        self.btnNext.isHidden = true

    }
    
    private func calculateScoreForQuestion(){
        let questionObj       = self.arrQuestions[currentQuestion]
        let strSelectedAnswer = self.arrOptions[selectedAnswerIndex]
        
        if questionObj.correct_answer == strSelectedAnswer{
            self.nScore += 1
        }
    }
    
//MARK:- ########## ACTION METHODS ############

    @IBAction func onBtnNext(_ sender: Any) {
        if self.selectedAnswerIndex == -1{
            print("Please select your answer!")
            return
        }

        self.calculateScoreForQuestion()
        self.currentQuestion += 1
        self.selectedAnswerIndex = -1 //unselect
        self.handleQuestionUI()

    }
    
    private func showLoader(){
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.show()
    }
    
    private func hideLoader(){
        SVProgressHUD.dismiss()
    }
    
}

//MARK:- ########## TABLE VIEW DELEGATES ############

extension QuizViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quizCell", for: indexPath) as! QuizCell
        cell.lblQuestion.text = self.arrOptions[indexPath.row]
        cell.viewBG.backgroundColor = (self.selectedAnswerIndex == indexPath.row) ? .gray : .white
        cell.lblQuestion.textColor  = (self.selectedAnswerIndex == indexPath.row) ? .white : .black

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.selectedAnswerIndex = indexPath.row
        
        if (self.currentQuestion + 1) == self.arrQuestions.count{
            self.btnNext.setTitle("Finish", for: .normal)
        }
        self.btnNext.isHidden    = false
        self.tblQuestion.reloadData()

    }
    
}

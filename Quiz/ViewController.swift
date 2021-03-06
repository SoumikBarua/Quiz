//
//  ViewController.swift
//  Quiz
//
//  Created by SB on 8/14/17.
//  Copyright © 2017 SB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //@IBOutlet var questionLabel: UILabel!
    @IBOutlet var currentQuestionLabel: UILabel!
    @IBOutlet var currentQuestionLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var nextQuestionLabel: UILabel!
    @IBOutlet var nextQuestionLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var answerLabel: UILabel!
    
    let questions: [String] = [
        "What is 7+7?",
        "What is the capital of Vermont?",
        "What is cognac made from?"
    ]
    let answers: [String] = [
        "14!",
        "Montpelier!",
        "Grapes!"
    ]
    var currentQuestionIndex: Int = 0
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentQuestionLabel.text = questions[currentQuestionIndex]
        
        updateOffScreenLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nextQuestionLabel.alpha = 0
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // To ensure the questions stay out of bounds during screen rotation
        coordinator.animate(alongsideTransition: nil) { _ in
            let screenWidth = self.view.frame.size.width
            self.nextQuestionLabelCenterXConstraint.constant = -screenWidth
            self.currentQuestionLabelCenterXConstraint.constant = 0
        }
    }
    
    
    // MARK: - Button press handling methods
    
    @IBAction func showNextQuestion(_sender: UIButton) {
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count {
            currentQuestionIndex = 0
        }
        let question: String = questions[currentQuestionIndex]
        nextQuestionLabel.text = question
        answerLabel.text = "???"
        
        animateLabelTransitions()
    }
    
    @IBAction func showAnswer(_sender: UIButton) {
        let answer: String = answers[currentQuestionIndex]
        answerLabel.text = answer
    }
    
    // MARK: - Animation handling methods
    
    func animateLabelTransitions() {
        
        // Force any outstanding layout changes to occur
        view.layoutIfNeeded()
        
        // Animate the alpha and the center X constraints
        let screenwidth = view.frame.width
        if UIDevice.current.orientation.isPortrait {
            print("\n portrait screenwidth is \(screenwidth)\n")
        } else {
            print("\n landscape screenwidth is \(screenwidth)\n")
        }
        self.nextQuestionLabelCenterXConstraint.constant = 0
        self.currentQuestionLabelCenterXConstraint.constant += screenwidth
        
        
        // Using UIView static method to create spring animation
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.70,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
                        self.currentQuestionLabel.alpha = 1
                        self.nextQuestionLabel.alpha = 1
                        
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        swap(&self.currentQuestionLabel,
                             &self.nextQuestionLabel)
                        swap(&self.currentQuestionLabelCenterXConstraint,
                             &self.nextQuestionLabelCenterXConstraint)
                        
                        self.updateOffScreenLabel()
        }
        )
    }
    
    func updateOffScreenLabel(){
        let screenwidth = view.frame.width
        nextQuestionLabelCenterXConstraint.constant = -screenwidth
    }
}

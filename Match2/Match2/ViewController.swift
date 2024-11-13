//
//  ViewController.swift
//  Match2
//
//  Created by Adilet Kistaubayev on 10.11.2024.
//

import UIKit

class ViewController: UIViewController {
    
    
    var images = ["1","2","3","4","5","6","7","8","1","2","3","4","5","6","7","8"]
    var state = [Int](repeating: 0, count: 16)
    var winState = [[0,8],[1,9],[2,10],[3,11],[4,12],[5,13],[6,14],[7,15]]
    var isActive = false
    var moveCount = 0
    var timer: Timer?
    var secondsElapsed = 0

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var moveCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame()
    }
    
    @IBAction func game(_ sender: UIButton) {
        guard state[sender.tag - 1] == 0 && !isActive else { return }
        
        sender.setBackgroundImage(UIImage(named: images[sender.tag - 1]), for: .normal)
        sender.backgroundColor = UIColor.white
        state[sender.tag - 1] = 1
        moveCount += 1
        updateMoveCountLabel()
        
        checkForMatch()
    }
    
    func checkForMatch() {
        let matchedIndices = state.enumerated().filter { $0.element == 1 }.map { $0.offset }
        
        if matchedIndices.count == 2 {
            isActive = true
            let firstIndex = matchedIndices[0]
            let secondIndex = matchedIndices[1]
            
            if images[firstIndex] == images[secondIndex] {
                state[firstIndex] = 2
                state[secondIndex] = 2
                isActive = false
                checkForWin()
            } else {
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(clear), userInfo: nil, repeats: false)
            }
        }
    }
    
    @objc func clear() {
        for i in 0..<state.count where state[i] == 1 {
            state[i] = 0
            if let button = view.viewWithTag(i + 1) as? UIButton {
                button.setBackgroundImage(nil, for: .normal)
                button.backgroundColor = UIColor.systemTeal
            }
        }
        isActive = false
    }
    
    func checkForWin() {
        if state.allSatisfy({ $0 == 2 }) {
            timer?.invalidate()
            showWinMessage()
            resetGame()
        }
    }
    
    func showWinMessage() {
        let alert = UIAlertController(title: "Congratulations!", message: "You won in \(moveCount) moves and \(secondsElapsed) seconds.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default) { _ in
            self.resetGame()
        })
        present(alert, animated: true)
    }
    
    func resetGame() {
        images.shuffle()
        state = [Int](repeating: 0, count: 16)
        moveCount = 0
        secondsElapsed = 0
        isActive = false
        updateMoveCountLabel()
        updateTimerLabel()
        
        for i in 1...16 {
            if let button = view.viewWithTag(i) as? UIButton {
                button.setBackgroundImage(nil, for: .normal)
                button.backgroundColor = UIColor.systemTeal
            }
        }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        secondsElapsed += 1
        updateTimerLabel()
    }
    
    func updateTimerLabel() {
        timerLabel.text = "Time: \(secondsElapsed) s"
    }
    
    func updateMoveCountLabel() {
        moveCountLabel.text = "Moves: \(moveCount)"
    }
}

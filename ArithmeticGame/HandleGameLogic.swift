//
//  HandleGameLogic.swift
//  ArithmeticGame
//
//  Created by 吳建豪 on 2017/3/23.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation


extension HomeViewController {
    
    func gameStart(){
      isEnbaleStartGame(false)
      initalGameStatus()
      let topicDict = topic.selectLevel(level/3+1)
      equationLabel.text = topicDict.keys.first!
      tempText = topicDict.keys.first!
      answer = topicDict.values.first!
      levelLabel.text = "Level \(level/3+1)-\(level % 3 + 1)"
      settingEffect(level % 3)
      startTimer()
        
    }
    
    func initalGameStatus(){
        isEnbaleAdjustNumber(true)
        currentNumber = 0
        countdownTime = 15.0
        counterLabel.text = "\(countdownTime)"
        updateNumber()
   
    }
    func startTimer(){
        guard countdowntimer == nil else {return}
        countdowntimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(countdownTimer), userInfo: nil, repeats: true)
        
    }
    func countdownTimer() {
        
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.minimumIntegerDigits = 1
        countdownTime -= 0.1
        counterLabel.text = "\(numberFormatter.string(from: NSNumber(value: countdownTime))!)"
        if ( counterLabel.text == "0.0"){
            countdowntimer?.invalidate()
            effectTimer?.invalidate()
            countdowntimer = nil
            effectTimer = nil
            increaseCountdowntimer.invalidate()
            decreaseCountdowntimer.invalidate()
            isEnbaleAdjustNumber(false)
            judgeIsCorrect()
            isEnbaleStartGame(true)
        }
        
    }
    
    func isEnbaleAdjustNumber(_ bool:Bool) {
        increaseView.isUserInteractionEnabled = bool
        decreaseView.isUserInteractionEnabled = bool
        increaseView.alpha = bool ? 1 : 0.5
        decreaseView.alpha = bool ? 1 : 0.5
        
    }
    func isEnbaleStartGame(_ bool:Bool) {
        startButton.isUserInteractionEnabled = bool
        startButton.alpha = bool ? 1 : 0.5
        
    }
    
    
    
    func judgeIsCorrect() {
        
        
        if isAddAdditionalNumber {
           answer = answer + additionalNumber
        }
        equationLabel.text = equationLabel.text! + " = \(answer)"
        if countingLabel.text == "\(answer)" {
            print ("correct")
            if isNeedSound {
            victoryMusicPlayer.play()
            }
            level += 1
        } else {
            if isNeedSound {
            failMusicPlayer.play()
            }
            print ("fail")
        }
        
    }
    
    func settingEffect(_ effect:Int) {
        isHidden = false
        additionalNumber = 0
        isAddAdditionalNumber = false
        if effect == 1 {
         effectTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(hiddenCountingLabel), userInfo: nil, repeats: true)
        }
        if effect == 2 {
        isAddAdditionalNumber = true
        let random:Double = Double(Int(arc4random_uniform(UInt32(6)))+5) / 10.0
         effectTimer = Timer.scheduledTimer(timeInterval: random, target: self, selector: #selector(addMovingNumber), userInfo: nil, repeats: true)
            
        }
        
        
    }
    func hiddenCountingLabel() {
        if Double(counterLabel.text!)!.truncatingRemainder(dividingBy:2.0) <= 1.0 {
        countingLabel.isHidden = false
        } else {
            countingLabel.isHidden = true
        }
    }
    func addMovingNumber() {
        additionalNumber += 1
        equationLabel.text = "\(tempText) + \(additionalNumber)"
    }
    
    
}

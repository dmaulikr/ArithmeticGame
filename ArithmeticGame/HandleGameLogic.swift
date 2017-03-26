//
//  HandleGameLogic.swift
//  ArithmeticGame
//
//  Created by 吳建豪 on 2017/3/23.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


extension HomeViewController {
    
    func gameStart(){
        if isNeedAddNumber { challengeNumber += 1}
        if challengeNumber > 10  && !UserDefaults.checkPro() {
            let alertController = UIAlertController(title: "running out of challenge times", message: "Please tap top title watch Ads to restore or buy Pro", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        if challengeNumber > 10  && UserDefaults.checkPro() { challengeNumber = 1}
            
      isGamePlaying = true
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
        hideAnswerLabel.isHidden = true
        challengeLabel.text = "Challenge \(challengeNumber)/10"
        currentNumber = 0
        countdownTime = 15.0
        counterLabel.text = "\(countdownTime)"
        updateNumber()
   
    }
    func startTimer(){
        guard countdowntimer == nil else {return}
        countdowntimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(countdownTimer), userInfo: nil, repeats: true)
       
//        countdowntimer = CADisplayLink(target: self, selector: #selector(countdownTimer))
//        countdowntimer?.add(to: .main, forMode: .defaultRunLoopMode)
//        countdowntimer?.add(to: .main, forMode: .UITrackingRunLoopMode)
//        countdowntimer?.frameInterval = 6
    }
    func countdownTimer() {
        
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.minimumIntegerDigits = 1
        countdownTime -= 0.1
        self.counterLabel.text = "\(self.numberFormatter.string(from: NSNumber(value: self.countdownTime))!)"
        checkSound()
        if ( counterLabel.text == "3.0" && level % 3 == 2 ){
        effectTimer?.invalidate()
        }
        if ( counterLabel.text == "0.0"){
            isGamePlaying = false
            countingLabel.isHidden = false
            isEnbaleAdjustNumber(false)
            increaseCountdowntimer.invalidate()
            decreaseCountdowntimer.invalidate()
            tenSecPlayer.stop()
            fiveSecPlayer.stop()
            countdowntimer?.invalidate()
            effectTimer?.invalidate()
            countdowntimer = nil
            effectTimer = nil
            judgeIsCorrect()
            isEnbaleStartGame(true)
        }
        
    }
    
    func checkSound() {
        if isNeedSound {
            if countdownTime > 5 && !tenSecPlayer.isPlaying {
                tenSecPlayer.volume = 1
                tenSecPlayer.play()
            } else if countdownTime < 5 && !fiveSecPlayer.isPlaying{
                tenSecPlayer.volume = 0
                fiveSecPlayer.play()
            } else {
                return
            }

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
            isNeedAddNumber = false
            startButton.setTitle("Continue", for: .normal)
            if isNeedSound {
            victoryMusicPlayer.play()
            }
            level += 1
            if level >= 29 { level = 29 }
            updateBestScore()
        } else {
            isNeedAddNumber = true
            if isNeedSound {
            failMusicPlayer.play()
            }
            startButton.setTitle("Continue", for: .normal)
            if challengeNumber >= 10 {
                startButton.setTitle("Restart", for: .normal)
                challengeLabel.text = UserDefaults.checkPro() ? "Challenge 0/10" : "Touch to restore challenge"
                level = 0
                restoreTreasure()
            }
            print ("fail")
        }
        
    }
    
    func updateBestScore() {
        if level > UserDefaults.bestScore() {
            UserDefaults.standard.set(level, forKey: "bestScore")
            bestLabel.text = "Best  \(UserDefaults.bestScore()/3+1)-\(UserDefaults.bestScore() % 3 + 1)"
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
        let random1 = Int(arc4random_uniform(UInt32(2)))
        addUnit = random1 == 0 ? 1 : -1
        addSymbol = random1 == 0 ? "+" : ""
        isAddAdditionalNumber = true
        randomEffectClock = Double(Int(arc4random_uniform(UInt32(6)))+5) / 10.0
         effectTimer = Timer.scheduledTimer(timeInterval: randomEffectClock, target: self, selector: #selector(addMovingNumber), userInfo: nil, repeats: true)
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
        
        additionalNumber += addUnit
        equationLabel.text = "\(tempText) \(addSymbol)\(additionalNumber)"
    }
    
    func useClock() {
        if isGamePlaying && isClockAvailable {
            isClockAvailable = false
            countdownTime += 3
            clockButton.isEnabled = false
            clockButton.alpha = 0.5
        }
    }
    func useHint() {
        if isGamePlaying && isHintAvailable {
            calculateHideAnswer()
            hideAnswerLabel.isHidden = false
            isHintAvailable = false
            hintButton.isEnabled = false
            hintButton.alpha = 0.5
        }
    }
    
    
    
    
    func restoreTreasure() {
        isClockAvailable = true
        isHintAvailable = true
        clockButton.isEnabled = true
        clockButton.alpha = 1.0
        hintButton.isEnabled = true
        hintButton.alpha = 1.0
    }
    func calculateHideAnswer() {
        var finalAnswer = answer
        if level % 3 == 2 {
            finalAnswer = finalAnswer + addUnit * Int(floor(12/randomEffectClock))
        }
        hideAnswer = "\(finalAnswer)"
        hideAnswer.characters.removeLast()
        hideAnswer = hideAnswer + "?"
        hideAnswerLabel.text = "Hint : \(hideAnswer)"
    }
    
}

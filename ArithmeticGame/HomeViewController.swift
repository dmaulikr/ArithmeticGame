//
//  ViewController.swift
//  ArithmeticGame
//
//  Created by 吳建豪 on 2017/3/21.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import UIKit
import LBTAComponents
import AVFoundation

class HomeViewController: UIViewController {

    
    var currentNumber = 0
    var increaseCountdowntimer = Timer()
    var decreaseCountdowntimer = Timer()
    var effectTimer:Timer?
    var countdowntimer:Timer?
    var quarterHeight:CGFloat = 0
    var frameWidth:CGFloat = 0
    let numberFormatter = NumberFormatter()
    var level = 0
    var answer = 1
    var additionalNumber = 0
    var isAddAdditionalNumber = false
    var tempText = ""
    var isHidden = false
    var isNeedSound = true
    var countdownTime = 15.0
    let topic = Topic.share
    var victoryMusicPlayer:AVAudioPlayer = AVAudioPlayer()
    var failMusicPlayer:AVAudioPlayer = AVAudioPlayer()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let victoryPath = Bundle.main.path(forResource: "correct", ofType: "mp3")
        let failPath = Bundle.main.path(forResource: "incorrect", ofType: "mp3")
        do {
            victoryMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: victoryPath!))
            victoryMusicPlayer.prepareToPlay()
            failMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: failPath!))
            failMusicPlayer.prepareToPlay()
        } catch {
            print  (Error.self)
        }

        view.backgroundColor = UIColor.white
        quarterHeight = view.frame.height/4
        frameWidth = view.frame.width
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillLayoutSubviews() {
        
        setupTimerView()
        setupCountingView()
        setupMenuVIew()
        setupClickView()
        

    }
    let timerBackgroundView = UIView()
    let titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Timer"
        return label
    }()

    let counterLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 60)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "15.0"
        return label
    }()

    func setupTimerView() {
        timerBackgroundView.backgroundColor = UIColor.mainBlue
        view.addSubview(timerBackgroundView)
        timerBackgroundView.addSubview(titleLabel)
        timerBackgroundView.addSubview(counterLabel)
        timerBackgroundView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: quarterHeight/3 + 70)
        titleLabel.anchor(timerBackgroundView.topAnchor, left: timerBackgroundView.leftAnchor, bottom: nil, right: timerBackgroundView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        counterLabel.anchor(titleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: quarterHeight/3)
        counterLabel.anchorCenterXToSuperview()
    }
    
    let levelLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MinecrafterAlt", size: 30)
        label.text = "Level 1"
        label.textAlignment = .center
        return label
    }()
    let countingImageView:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "equation1")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let countingLabel:StrokeLabel = {
        let label = StrokeLabel()
        label.textColor = UIColor.buyRed
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        label.text = "0"
        return label
    }()
    let equationImageView:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "question1")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let equationLabel:StrokeLabel = {
        let label = StrokeLabel()
        label.text = "( 4 + 5 ) ＊ 3 "
        label.textColor = UIColor.buyRed
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    func setupCountingView(){
        view.addSubview(levelLabel)
        view.addSubview(equationImageView)
        view.addSubview(equationLabel)
        view.addSubview(countingImageView)
        view.addSubview(countingLabel)
        
//        timeTitleLabel.anchor(titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: frameWidth/3, heightConstant: quarterHeight/3)
//        counterLabel.anchor(timeTitleLabel.topAnchor, left: timeTitleLabel.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: quarterHeight/3)
        
        
        levelLabel.anchor(timerBackgroundView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: quarterHeight/3)
        levelLabel.anchorCenterXToSuperview()
        equationImageView.anchor(levelLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frameWidth/3, heightConstant: quarterHeight/3)
        equationLabel.anchor(equationImageView.topAnchor, left: equationImageView.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: quarterHeight/3)
        countingImageView.anchor(equationImageView.bottomAnchor, left: equationImageView.leftAnchor, bottom: nil, right: equationImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: quarterHeight/3)
        countingLabel.anchor(equationLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: quarterHeight/3)
        countingLabel.anchorCenterXToSuperview()
    }
    
    lazy var startButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("Start", for: .normal)
        btn.backgroundColor = UIColor.htmlBlue
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(gameStart), for: .touchUpInside)
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: -1.5, height: 1.5)
        btn.layer.cornerRadius = 15
        btn.layer.shadowOpacity = 0.8
        btn.layer.shadowRadius = 1.0

        return btn
    }()
    lazy var soundButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("Sound on", for: .normal)
        btn.backgroundColor = UIColor.htmlBlue
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(switchSound), for: .touchUpInside)
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: -1.5, height: 1.5)
        btn.layer.cornerRadius = 15
        btn.layer.shadowOpacity = 0.8
        btn.layer.shadowRadius = 1.0

        return btn
    }()
    
    
    func setupMenuVIew() {
        view.addSubview(startButton)
        view.addSubview(soundButton)
        startButton.anchor(countingLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: quarterHeight/3)
        startButton.anchorCenterXToSuperview()
        soundButton.anchor(startButton.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: quarterHeight/3)
        soundButton.anchorCenterXToSuperview()
    }
    
   
    func switchSound(){
        isNeedSound = !isNeedSound
        soundButton.setTitle(isNeedSound ? "Sound on" : "Sound off", for: .normal)
        
    }
    
    
    
    lazy var increaseView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.adoptGreen
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 30
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "add")
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(LongPressToIncrease))
        longPressGestureRecognizer.minimumPressDuration = 0.3
        iv.addGestureRecognizer(longPressGestureRecognizer)
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToIncrease)))
        return iv
    }()
    lazy var decreaseView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.buyRed
        iv.layer.cornerRadius = 30
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "minus")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(LongPressToDecrease))
        longPressGestureRecognizer.minimumPressDuration = 0.3
        iv.addGestureRecognizer(longPressGestureRecognizer)
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToDecrease)))
        return iv
    }()
    
    func setupClickView() {
        view.addSubview(increaseView)
        view.addSubview(decreaseView)
        increaseView.anchor(nil , left: view.leftAnchor, bottom: view.bottomAnchor  , right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 30, rightConstant: 0, widthConstant: frameWidth/2-20, heightConstant: 60)
        decreaseView.anchor(nil, left: nil, bottom: increaseView.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: frameWidth/2-20, heightConstant: 60)
    }
    
    
    
    func LongPressToIncrease(sender:UIGestureRecognizer){
        if sender.state == .began {
            print("began")
            increaseCountdowntimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(increaseNumber), userInfo: nil, repeats: true)
        }
        if sender.state == .ended {
            print("end")
            increaseCountdowntimer.invalidate()
        }
    }
    func tapToIncrease(sender:UIGestureRecognizer) {
         increaseNumber()
    }
    func increaseNumber() {
        currentNumber += 1
        updateNumber()
    }
    func LongPressToDecrease(sender:UIGestureRecognizer){
        if sender.state == .began {
            print("began")
            decreaseCountdowntimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(decreaseNumber), userInfo: nil, repeats: true)
        }
        if sender.state == .ended {
            print("end")
            decreaseCountdowntimer.invalidate()
        }
    }
    func tapToDecrease(sender:UIGestureRecognizer) {
        decreaseNumber()
    }
    func decreaseNumber() {
        currentNumber += -1
        updateNumber()
    }
    
    func updateNumber(){
        countingLabel.text = "\(currentNumber)"
   //     counterLabel.text = "\(countdownTime)"
        
    }
    
}


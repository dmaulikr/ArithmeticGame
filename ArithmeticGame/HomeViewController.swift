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
    var countdowntimer: Timer?
    var quarterHeight:CGFloat = 0
    var frameWidth:CGFloat = 0
    let numberFormatter = NumberFormatter()
    var answer = 1
    var additionalNumber = 0
    var isAddAdditionalNumber = false
    var tempText = ""
    var isHidden = false
    var isNeedSound = true
    var isGamePlaying = false 
    var countdownTime = 15.0
    let topic = Topic.share
    var victoryMusicPlayer:AVAudioPlayer = AVAudioPlayer()
    var failMusicPlayer:AVAudioPlayer = AVAudioPlayer()
    var tenSecPlayer:AVAudioPlayer = AVAudioPlayer()
    var fiveSecPlayer:AVAudioPlayer = AVAudioPlayer()
    var addUnit = 0
    var addSymbol = ""
    var hideAnswer = ""
    var randomEffectClock = 0.0
    var audioSession: AVAudioSession!
    var challengeNumber:Int {
        get {
        return UserDefaults.clickNumber()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "clickNumber")
        }
    }
    var isNeedAddNumber:Bool {
        get {
            return UserDefaults.isNeedAddNumber()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isNeedAddNumber")
        }
    }
    
    var level:Int {
        get {
            return UserDefaults.level()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "level")
        }
    }
    var isClockAvailable:Bool {
        get {
            return UserDefaults.isClockAvailable()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isClockAvailable")
        }
    }
    var isHintAvailable:Bool {
        get {
            return UserDefaults.isHintAvailable()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isHintAvailable")
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadAd()
        let victoryPath = Bundle.main.path(forResource: "correct", ofType: "mp3")
        let failPath = Bundle.main.path(forResource: "incorrect", ofType: "mp3")
        let tenSecPath = Bundle.main.path(forResource: "10sec", ofType: "mp3")
        let fiveSecPath = Bundle.main.path(forResource: "5sec", ofType: "aif")
        audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with:.defaultToSpeaker)
            try audioSession.setActive(true)
            victoryMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: victoryPath!))
            victoryMusicPlayer.prepareToPlay()
            failMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: failPath!))
            failMusicPlayer.prepareToPlay()
            tenSecPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: tenSecPath!))
            tenSecPlayer.prepareToPlay()
            fiveSecPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fiveSecPath!))
            fiveSecPlayer.numberOfLoops = 2
            fiveSecPlayer.volume = 0.5
            fiveSecPlayer.prepareToPlay()
            
        } catch {
            print  (Error.self)
        }

        view.backgroundColor = UIColor.white
        quarterHeight = view.frame.height/4
        frameWidth = view.frame.width
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillLayoutSubviews() {
        setupTitleView()
        setupBackgroundView()
        setupTimerView()
        setupCountingView()
        setupMenuVIew()
        setupClickView()
    }
    lazy var titleView:UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(restoreNumber)))
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.mainBlue
        return view
    }()
    lazy var challengeLabel:UILabel = {
        let label = UILabel()
        label.text = "Challenge \(self.challengeNumber)/10"
        label.textColor = UIColor.white
        if self.challengeNumber >= 10 && self.isNeedAddNumber {
          label.text = "Tap here to restore challenge"
        }
        return label
    }()
    func setupTitleView() {
        
        titleView.addSubview(challengeLabel)
        challengeLabel.anchorCenterSuperview()
        titleView.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 40)
        titleView.anchorCenterSuperview()
        navigationItem.titleView = titleView
    }
    
    func restoreNumber() {
        if challengeNumber >= 10 {
            playVideo()
        }
    }
    
    let timerBackgroundView = UIView()
    let titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Timer"
        return label
    }()

    let counterLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 60)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = "15.0"
        return label
    }()
    let bestLabel:StrokeLevelLabel = {
        let label = StrokeLevelLabel(6)
        label.text = "Best  \(UserDefaults.bestScore()/3+1)-\(UserDefaults.bestScore() % 3 + 1)"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    func setupTimerView() {
        timerBackgroundView.backgroundColor = UIColor.clear
        view.addSubview(timerBackgroundView)
        timerBackgroundView.addSubview(bestLabel)
        timerBackgroundView.addSubview(titleLabel)
        timerBackgroundView.addSubview(counterLabel)
        bestLabel.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 100, heightConstant: 40)
        timerBackgroundView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: quarterHeight/3 + 40)
        titleLabel.anchor(timerBackgroundView.topAnchor, left: timerBackgroundView.leftAnchor, bottom: nil, right: timerBackgroundView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        counterLabel.anchor(titleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: quarterHeight/3)
        counterLabel.anchorCenterXToSuperview()
    }
    
    let backgroundImageView:UIImageView = {
        let backImageView = UIImageView()
        backImageView.image = #imageLiteral(resourceName: "background")
        backImageView.contentMode = .scaleAspectFill
        backImageView.alpha = 0.3
        return backImageView
    }()
    
    
    func setupBackgroundView(){
        
        view.addSubview(backgroundImageView)
        backgroundImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    
    lazy var levelLabel:StrokeLevelLabel = {
        let label = StrokeLevelLabel(10)
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "Level \(self.level/3+1)-\(self.level % 3 + 1)"
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    let countingImageView:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "equation1")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let countingLabel:UILabel = {
        let label = UILabel()
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
        label.text = "a + b - c = ???"
        label.textColor = UIColor.buyRed
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    let hideAnswerLabel:UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.buyRed
        return label
    }()
    
    func setupCountingView(){
        view.addSubview(levelLabel)
        view.addSubview(equationImageView)
        view.addSubview(equationLabel)
        view.addSubview(countingImageView)
        view.addSubview(countingLabel)
        view.addSubview(hideAnswerLabel)
        
        levelLabel.anchor(timerBackgroundView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: quarterHeight/3)
        levelLabel.anchorCenterXToSuperview()
        equationImageView.anchor(levelLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frameWidth/3, heightConstant: quarterHeight/3)
        equationLabel.anchor(equationImageView.topAnchor, left: equationImageView.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: quarterHeight/3)
        countingImageView.anchor(equationImageView.bottomAnchor, left: equationImageView.leftAnchor, bottom: nil, right: equationImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: quarterHeight/3)
        countingLabel.anchor(equationLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: quarterHeight/3)
        countingLabel.anchorCenterXToSuperview()
        hideAnswerLabel.anchor(countingLabel.topAnchor, left: countingLabel.rightAnchor, bottom: countingLabel.bottomAnchor, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 0)
        
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
    lazy var clockButton:UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "clock"), for: .normal)
        btn.addTarget(self, action: #selector(useClock), for: .touchUpInside)
        btn.alpha =  self.isClockAvailable ? 1 : 0.5
        btn.isEnabled = self.isClockAvailable
        return btn
    }()
    lazy var hintButton:UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "hint"), for: .normal)
        btn.addTarget(self, action: #selector(useHint), for: .touchUpInside)
        btn.alpha =  self.isHintAvailable ? 1 : 0.5
        btn.isEnabled = self.isHintAvailable
        return btn
    }()
    
    func setupMenuVIew() {
        view.addSubview(startButton)
        view.addSubview(soundButton)
        view.addSubview(clockButton)
        view.addSubview(hintButton)
        startButton.anchor(countingLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frameWidth/2 , heightConstant: quarterHeight/3 - 10)
        startButton.anchorCenterXToSuperview()
        soundButton.anchor(startButton.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frameWidth/2  , heightConstant: quarterHeight/3 - 10)
        soundButton.anchorCenterXToSuperview()
        clockButton.anchor(soundButton.bottomAnchor, left: nil, bottom: nil, right: view.centerXAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: frameWidth/7, heightConstant: quarterHeight/3 )
        hintButton.anchor(clockButton.topAnchor, left: view.centerXAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: frameWidth/7, heightConstant: quarterHeight/3 )
        
        
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
    
    let hintLabel:UILabel = {
        let label = UILabel()
        label.text = "Tap or Press the + - button to adjust the number"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    
    func setupClickView() {
        view.addSubview(increaseView)
        view.addSubview(decreaseView)
        view.addSubview(hintLabel)
        increaseView.anchor(nil , left: view.leftAnchor, bottom: view.bottomAnchor  , right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 30, rightConstant: 0, widthConstant: frameWidth/2-20, heightConstant: quarterHeight/2-10)
        decreaseView.anchor(nil, left: nil, bottom: increaseView.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: frameWidth/2-20, heightConstant: quarterHeight/2-10)
        hintLabel.anchor(nil, left: nil, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        hintLabel.anchorCenterXToSuperview()
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
           self.countingLabel.text = "\(self.currentNumber)"
        //     counterLabel.text = "\(countdownTime)"
        
    }
    
}


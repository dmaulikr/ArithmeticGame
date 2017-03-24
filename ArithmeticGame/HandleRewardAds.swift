//
//  HandleRewardAds.swift
//  ArithmeticGame
//
//  Created by 吳建豪 on 2017/3/24.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import UnityAds
import Firebase

var inProcess = false
var rewardBasedVideo: GADRewardBasedVideoAd?
extension HomeViewController : GADRewardBasedVideoAdDelegate {
   
    func playVideo(){
        if rewardBasedVideo?.isReady == true {
            UIWindow.removeStatusBar()
            rewardBasedVideo?.present(fromRootViewController: self)
        }
    }
//    func unityAdsReady(_ placementId: String) {
//        print("here")
//    }
//    func unityAdsDidError(_ error: UnityAdsError, withMessage message: String) {
//        
//    }
//    func unityAdsDidStart(_ placementId: String) {
//        
//    }
//    func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState) {
//        
//    }
//
    
    
    
    func reloadAd(){
    //    UnityAds.initialize("1359704", delegate: self)
        if inProcess == false {
            inProcess = true
            rewardBasedVideo = GADRewardBasedVideoAd.sharedInstance()
            rewardBasedVideo?.delegate = self
            rewardBasedVideo?.load(GADRequest(),
                                   withAdUnitID: "ca-app-pub-8818309556860374/9435954446")
        }
        
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load: \(error.localizedDescription)")
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        
        print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
        UIWindow.addStatusBar()
        inProcess = false
        reloadAd()
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        UserDefaults.standard.set(0, forKey: "clickNumber")
        challengeLabel.text = "Challenge \(self.challengeNumber)/10"
        //  update()
    }

    
}

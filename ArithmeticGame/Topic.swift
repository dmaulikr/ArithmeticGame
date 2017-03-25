//
//  Topic.swift
//  ArithmeticGame
//
//  Created by 吳建豪 on 2017/3/23.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation

struct Topic {
    
    static let share = Topic()
    
    func selectLevel(_ level:Int) -> [String:Int] {
        switch level {
        case 1 :
            return makeLevelOneTopic()
        case 2 :
            return makeLevelTwoTopic()
        case 3 :
            return makeLevelThreeTopic()
        case 4 :
            return makeLevelFourTopic()
        case 5 :
            return makeLevelFiveTopic()
        case 6 :
            return makeLevelSixTopic()
        case 7 :
            return makeLevelSevenTopic()
        case 8 :
            return makeLevelEightTopic()
        case 9 :
            return makeLevelNineTopic()
        case 10 :
            return makeLevelTenTopic()
        default :
            return [String:Int]()
        }
    }
    
    // a+b
    func makeLevelOneTopic() -> [String:Int] {
        let (bigger,smaller) = preduceRandomAnyTwoNumber()
        let equation = "\(bigger) + \(smaller)"
        let answer = bigger + smaller
        return [equation:answer]
        
    }
    // a-b
    func makeLevelTwoTopic() -> [String:Int] {
        let (bigger,smaller) = preduceRandomAnyTwoNumber()
        let equation = "\(bigger) - \(smaller)"
        let answer = bigger - smaller
        return [equation:answer]
        
    }
    // a*b
    func makeLevelThreeTopic() -> [String:Int] {
        let random1 = Int(arc4random_uniform(UInt32(31)))+10
        let random2 = Int(arc4random_uniform(UInt32(10)))+1
        let equation = "\(random1) ＊ \(random2)"
        let answer = random1 * random2
        return [equation:answer]
        
    }
    // a/b
    func makeLevelFourTopic() -> [String:Int] {
    return makeDivide()
    }
    
    // a±b±c
    func makeLevelFiveTopic() -> [String:Int] {
        let prefixEquation = self.makeLevelOneTopic()
        let (symbol,randomOperator) = self.randomOperator()
        let random1 = Int(arc4random_uniform(UInt32(prefixEquation.values.first!/2)))
        let equation = "\(prefixEquation.keys.first ?? "") \(symbol) \(random1)"
        let answer = randomOperator(prefixEquation.values.first!,random1)
        return [equation:answer]
    }
    
    // (a*b)±c
    func makeLevelSixTopic() -> [String:Int] {
        let random1 = Int(arc4random_uniform(UInt32(30)))+1
        let random2 = Int(arc4random_uniform(UInt32(10)))+1
        let random3 = Int(arc4random_uniform(UInt32(random1*random2)))
        let (symbol,randomOperator) = self.randomOperator()
        let equation = "(\(random1) * \(random2) \(symbol) \(random3))"
        let answer = randomOperator(random1*random2,random3)
        return [equation:answer]
    }
    // (a*b) 1x * 1x
    func makeLevelSevenTopic() -> [String:Int] {
        let random1 = Int(arc4random_uniform(UInt32(11)))+10
        let random2 = Int(arc4random_uniform(UInt32(11)))+10
        let equation = "(\(random1) * \(random2) )"
        let answer = random1*random2
        return [equation:answer]
    }
    //(a*b)±c  1x * 1x ± c
    func makeLevelEightTopic() -> [String:Int] {
        let random1 = Int(arc4random_uniform(UInt32(11)))+10
        let random2 = Int(arc4random_uniform(UInt32(11)))+10
        let random3 = Int(arc4random_uniform(UInt32(random1*random2)))
        let (symbol,randomOperator) = self.randomOperator()
        let equation = "(\(random1) * \(random2) \(symbol) \(random3))"
        let answer = randomOperator(random1*random2,random3)
        return [equation:answer]
        
    }
    //(a*b)±(c/d)
    func makeLevelNineTopic() -> [String:Int] {
        let random1 = Int(arc4random_uniform(UInt32(31)))+10
        let random2 = Int(arc4random_uniform(UInt32(10)))+1
        let divideDict = self.makeDivide()
        let (symbol,randomOperator) = self.randomOperator()
        let equation = "(\(random1) * \(random2)) \(symbol) \(divideDict.keys.first!)"
        let answer = randomOperator(random1*random2,divideDict.values.first!)
        return [equation:answer]
    }
    //(a*b)±(c/d)
    func makeLevelTenTopic() -> [String:Int] {
        let random1 = Int(arc4random_uniform(UInt32(11)))+10
        let random2 = Int(arc4random_uniform(UInt32(11)))+10
        let divideDict = self.makeDivide()
        let (symbol,randomOperator) = self.randomOperator()
        let equation = "(\(random1) * \(random2)) \(symbol) \(divideDict.keys.first!)"
        let answer = randomOperator(random1*random2,divideDict.values.first!)
        return [equation:answer]
    }
    
    
    
    func preduceRandomAnyTwoNumber() -> (bigger:Int, smaller:Int) {
        let random1 = Int(arc4random_uniform(UInt32(250)))
        let random2 = Int(arc4random_uniform(UInt32(250)))
        
        if random1 == random2 {
            return (bigger:random1+Int(arc4random_uniform(UInt32(100))), smaller:random2)
        }
        else if  random1 > random2{
            return (bigger:random1, smaller:random2)
        } else {
            return (bigger:random2, smaller:random1)

        }
    }
    func randomOperator() -> (symbol:String,(Int,Int)->Int) {
        let operatorNumber = Int(arc4random_uniform(UInt32(2)))
        return operatorNumber == 0 ? ("+",add) : ("-",minus)
    }
    func add(_ a:Int,_ b:Int) -> Int {
        return a + b
    }
    func minus(_ a:Int,_ b:Int) -> Int {
        return a - b
    }
    
    let primeNumber = [2,3,4,5,6,7,8]
    
    
    func makeDivide() -> [String:Int] {
        var sum = 1
        var divisor = 1
        var divisorArray = [Int]()
        for _ in 0...3 {
            let random = Int(arc4random_uniform(UInt32(primeNumber.count)))
            sum = sum * primeNumber[random]
            divisorArray.append(primeNumber[random])
        }
        let random2 = Int(arc4random_uniform(UInt32(2)))
        
        for index in 0...random2 {
            divisor = divisor * divisorArray[index]
        }
        let equation = "(\(sum) / \(divisor) )"
        let answer = sum / divisor
        return [equation:answer]
    }
    
    
}

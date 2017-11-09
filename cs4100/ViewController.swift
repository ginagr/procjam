//
//  ViewController.swift
//  cs4100
//
//  Created by GGR on 11/6/17.
//  Copyright © 2017 ggr. All rights reserved.
//

import UIKit

//shuffler for random pattern
extension MutableCollection {
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var pattern1: UIButton!
    @IBOutlet weak var pattern2: UIButton!
    @IBOutlet weak var pattern3: UIButton!
    @IBOutlet weak var pattern4: UIButton!
    @IBOutlet weak var pattern5: UIButton!
    
    var level = 1
    
    var isHighLighted:Bool = false
    var firstColor: UIColor!
    var firstButton: UIButton!
    
    var colorArray=[UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.orange]
    
    var allButtons = [UIButton] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get screen sizes
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let height = (screenHeight/20)
        for index in 0...20 {
            let y = height * CGFloat(index)
            let button = UIButton(frame: CGRect(x: 20, y: y, width: 200, height: height - 5))
            button.backgroundColor = colorArray[generateRandomColor(level)]
            button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            button.setTitle("Num \(index)", for: .normal)
            allButtons.append(button)
            self.view.addSubview(button)
        }
        
        var patternButtons = [UIButton] () //append all pattern buttons to array
        patternButtons.append(pattern1)
        patternButtons.append(pattern2)
        patternButtons.append(pattern3)
        patternButtons.append(pattern4)
        patternButtons.append(pattern5)
        
        for button in patternButtons { //hide pattern buttons
            button.isHidden = true
        }
        
        var pattern = [UIColor] ()
        pattern = generateRandomPattern(level) //get randomly generated pattern
        
        for (index, element) in pattern.enumerated() { //put pattern in pattern buttons
            patternButtons[index].backgroundColor = element
            patternButtons[index].isHidden = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickButton(sender: UIButton!) {
        if isHighLighted == false { //first button already clicked
            sender.layer.shadowOpacity = 0.5 //add shadow
            isHighLighted = true;
            
            firstColor = sender.backgroundColor; //save color
            firstButton = sender; //save button
        } else {
            UIButton.animate(withDuration: 0.75) {
                self.firstButton.layer.shadowOpacity = 0.0 //shadow
                self.firstButton.backgroundColor = sender.backgroundColor; //switch colors
                sender.backgroundColor = self.firstColor;
            }
            isHighLighted = false //reset
            checkPattern()
        }
    }
    
    func generateRandomColor(_ level:Int) -> Int {
        if level == 1 { //three colors
            return Int(arc4random_uniform(UInt32(3)))
        } else if level == 2 { //four colors
            return Int(arc4random_uniform(UInt32(4)))
        } else { //five colors
            return Int(arc4random_uniform(UInt32(5)))
        }
    }
    
    //TODO: make sure there is at least of one color
    func generateRandomPattern(_ level:Int) -> [UIColor] {
        if level == 1 { //three colors, pattern of three
            let pattern = [colorArray[0], colorArray[1], colorArray[2]]
            return shuffleColor(array: pattern)
        } else if level == 2 {//four colors, pattern of four
            let pattern = [colorArray[0], colorArray[1], colorArray[2], colorArray[3]]
            return shuffleColor(array: pattern)
        } else { //five colors, pattern of five
            let pattern = [colorArray[0], colorArray[1], colorArray[2], colorArray[3], colorArray[4]]
            return shuffleColor(array: pattern)
        }
    }
    
    func shuffleColor(array: [UIColor]) -> [UIColor] {
        var tempArray = array
        for _ in 0...5 {
            for index in 0...array.count - 1 {
                let rand = Int(arc4random_uniform(UInt32(array.count - 1)))
                let temp = tempArray[index]
                tempArray[index] = tempArray[rand]
                tempArray[rand] = temp
            }
        }
        return tempArray
    }
    
    func checkPattern() {
        var first = false;
        var second = false
        var third = false
        var fourth = false
        var fifth = false
        
        var firstIndex = 0;
        
        switch level {
        case 1:
            for (index, btn) in allButtons.enumerated() {
                if !first {
                    if btn.backgroundColor == pattern1.backgroundColor { //first color is right
                        first = true
                        second = false
                        firstIndex = index
                    }
                } else if !second { //checking second
                    if btn.backgroundColor == pattern2.backgroundColor { //second color is right
                        second = true
                    } else if btn.backgroundColor == pattern1.backgroundColor { //second color is wrong
                        first = true
                        firstIndex = index
                    } else {
                        first = false
                    }
                } else { //already found second
                    if btn.backgroundColor == pattern3.backgroundColor { //found pattern, delete
                        patternFound(index: firstIndex)
                        first = false
                        second = false
                    } else { //not pattern, reset
                        first = false
                        second = false
                    }
                }
            }
        case 2:
            print("The last letter of the alphabet")
        default:
            print("Some other character")
        }
    }
    
    func patternFound(index: Int) {
        print("INDEX: \(index)")
        if level == 1 {
            allButtons[index].backgroundColor = UIColor.black
            allButtons[index+1].backgroundColor = UIColor.black
            allButtons[index+2].backgroundColor = UIColor.black
            
            let width = allButtons[index].frame.size.width
            let height = allButtons[index].frame.size.height
            let x = allButtons[index].frame.origin.x
            
            UIView.animate(withDuration: 1.0, animations:{
                self.allButtons[index].frame = CGRect(x: x + 100, y: self.allButtons[index].frame.origin.y, width: width, height: height)
                self.allButtons[index+1].frame = CGRect(x: x + 100, y: self.allButtons[index+1].frame.origin.y, width: width, height: height)
                self.allButtons[index+2].frame = CGRect(x: x + 100, y: self.allButtons[index+2].frame.origin.y, width: width, height: height)
            })
            
//            for i in (-1...(index+2)).reversed() {
//
//                UIView.animate(withDuration: 1.0, animations:{
//                    let button = self.allButtons[index]
//                    button.frame = CGRect(x: button.frame.origin.x + 25, y: button.frame.origin.y + 25, width: button.frame.size.width, height: button.frame.size.height)
//                })
            
//            }
            
            
//            if index > 2 { //make sure in bounds
//                allButtons[index].backgroundColor = allButtons[index-3].backgroundColor
//                allButtons[index+1].backgroundColor = allButtons[index-2].backgroundColor
//                allButtons[index+2].backgroundColor = allButtons[index-1].backgroundColor
//            }
        }
    }
}


//
//  RoundButton.swift
//  Calculator
//
//  Created by Finley on 2022/03/17.
//

import UIKit

@IBDesignable

class RoundButton: UIButton {

    @IBInspectable var isRound: Bool = false{
        didSet{
            if isRound{
                self.layer.cornerRadius = self.frame.height / 2
            }
        }
        }
    }
    


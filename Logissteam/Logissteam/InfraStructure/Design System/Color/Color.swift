//
//  Color.swift
//  NomadStoryTask
//
//  Created by Ahmed on 6/17/22.
//

import Foundation
import UIKit

extension DesignSystem {
    
    enum Colors: String {
        case PrimaryWhite              =  "PrimaryWhite"
        case PrimaryOrange             =  "PrimaryOrange"
        case PrimaryDarkOrange         =  "PrimaryDarkOrange"
        case PrimaryLightOrange        =  "PrimaryLightOrange"
        case PrimarySecondLightOrange  =  "PrimarySecondLightOrange"
        case PrimaryThirdLightOrange   =  "PrimaryThirdLightOrange"
        case PrimaryFourthLightOrange  =  "PrimaryFourthLightOrange"
        case PrimaryGray               =  "PrimaryGray"
        case PrimaryLightGray          =  "PrimaryLightGray"
        case PrimaryDarkBlue           =  "PrimaryDarkBlue"
        case PrimaryDarkGray           =  "PrimaryDarkGray"
        case PrimaryYellow             =  "PrimaryYellow"
        case PrimaryLightBlue          =  "PrimaryLightBlue"
        case PrimarySecondGray         =  "PrimarySecondGray"
        case PrimaryThirdGray          =  "PrimaryThirdGray"
        case PrimaryFourthGray         =  "PrimaryFourthGray"
        case PrimaryFifthGray          =  "PrimaryFifthGray"
        case PrimarySixthGray          =  "PrimarySixthGray"
        case PrimarySeventhGray        =  "PrimarySeventhGray"
        case PrimaryEightthGray        =  "PrimaryEightthGray"
        case PrimaryNighnthGray        =  "PrimaryNighnthGray"
        case PrimaryTenthGray          =  "PrimaryTenthGray"
        case Primary11thGray           =  "Primary11thGray"
        case Primary12thGray           =  "Primary12thGray"
        case PrimarySecondWhite        =  "PrimarySecondWhite"
        case PrimaryRed                =  "PrimaryRed"
        case PrimaryDarkRed            =  "PrimaryDarkRed"
        case PrimaryDarkBrown          =  "PrimaryDarkBrown"
        case PrimaryGreen              =  "PrimaryGreen"
        case PrimaryDarkGreen          =  "PrimaryDarkGreen"
        
        var color: UIColor {
            return UIColor(named: self.rawValue)!
        }
    }
}

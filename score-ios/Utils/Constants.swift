//
//  Constants.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/11/24.
//

import SwiftUI

struct Constants {

    enum Colors {
        
        // Greys
        static let black = Color(hex: 0x000000)
        static let white = Color(hex: 0xFFFFFF)
        static let grey_text = Color(hex: 0x777777)
        static let grey_liner = Color(hex: 0xC2C2C2)
//        static let greybg = Color(hex: 0xF0F1F2)
//        static let grey00 = Color(hex: 0xF7F7F7)
//        static let grey01 = Color(hex: 0xEFF1F4)
//        static let grey02 = Color(hex: 0xDED9D9)
//        static let grey03 = Color(hex: 0x606060)

        // Others
        static let red = Color(hex: 0xFF4F4F)
//        static let brown = Color(hex: 0xCE9D9D)
//        static let blue = Color(hex: 0x4387CB)
//        static let green = Color(hex: 0x378C27)
//        static let purple = Color(hex: 0x8643CB)
//        static let yellow = Color(hex: 0xE9B140)
        
        // Customs
        static let selected = red
        static let selectedText = white
        static let unselected = grey_liner
        static let unselectedText = grey_text
        
    }

    enum Fonts {
        static let title = Font.system(size: 36, weight: .bold, design: .default)
        static let header = Font.system(size: 24, weight: .bold, design: .default)
        static let subheader = Font.system(size: 18, weight: .bold, design: .default)
        static let bodyBold = Font.system(size: 16, weight: .semibold, design: .default)
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        static let caption = Font.system(size: 12, weight: .regular, design: .default)
    }

}

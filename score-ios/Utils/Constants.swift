//
//  Constants.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/11/24.
//

import SwiftUI

struct Constants {

    enum Icons {
        static let locationIcon = "Location-g"
    }
    
    enum Colors {
        
        // grays
        static let black = Color(hex: 0x000000)
        static let white = Color(hex: 0xFFFFFF)
        static let gray_text = Color(hex: 0x616161)
        static let gray_liner = Color(hex: 0xC2C2C2)
        static let gray_border = Color(hex: 0xEAEAEA)
        static let gray_icons = Color(hex: 0x777777)
//        static let graybg = Color(hex: 0xF0F1F2)
//        static let gray00 = Color(hex: 0xF7F7F7)
//        static let gray01 = Color(hex: 0xEFF1F4)
//        static let gray02 = Color(hex: 0xDED9D9)
//        static let gray03 = Color(hex: 0x606060)

        // Design system
        static let primary_red = Color(hex: 0xA5210D)
        static let gradient_red = Color(red: 179 / 255, green: 27 / 255, blue: 27 / 255, opacity: 0.4)
        static let gradient_blue = Color(red: 1 / 255, green: 31 / 255, blue: 91 / 255, opacity: 0.4)
        static let crimson = Color(hex: 0xA5210D)

        // Customs
        static let selected = primary_red
        static let selectedText = white
        static let unselected = gray_liner
        static let unselectedText = gray_text
        static let iconGray = gray_icons
    
        
    }

    struct Fonts {
        // Header fonts
        struct Header {
            static let h1 = Font.custom("Poppins SemiBold", size: 24)
            static let h2 = Font.custom("Poppins Medium", size: 18)
            static let h3 = Font.custom("Poppins Medium", size: 14)
            static let h4 = Font.custom("Poppins Medium", size: 12)
        }

        // Body fonts
        struct Body {
            static let light = Font.custom("Poppins Light", size: 14)
            static let normal = Font.custom("Poppins Regular", size: 14)
            static let medium = Font.custom("Poppins Medium", size: 14)
            static let semibold = Font.custom("Poppins SemiBold", size: 14)
            static let bold = Font.custom("Poppins Bold", size: 14)
        }

        // Label fonts
        struct Label {
            static let light = Font.custom("Poppins Light", size: 12)
            static let normal = Font.custom("Poppins Regular", size: 12)
            static let medium = Font.custom("Poppins Medium", size: 12)
            static let semibold = Font.custom("Poppins SemiBold", size: 12)
        }

        static let countdownNum = Font.custom("Poppins Medium", size: 36)
        static let gameScore = Font.custom("Poppins SemiBold", size: 18)
        static let gameTitle = Font.custom("Poppins Medium", size: 18)
        static let gameText = Font.custom("Poppins Regular", size: 14)
        static let buttonLabel = Font.custom("Poppins Medium", size: 14)
        static let gameDate = Font.custom("Poppins Regular", size: 12)
        static let sportLabel = Font.custom("Poppins Regular", size: 12)
        static let filterLabel = Font.custom("Poppins Regular", size: 24)
        static let semibold24 = Font.custom("Poppins SemiBold", size: 24)
        static let semibold18 = Font.custom("Poppins SemiBold", size: 18)
        static let medium14 =  Font.custom("Poppins Medium", size: 14)
        static let medium18 = Font.custom("Poppins Medium", size: 18)
        static let regular14 = Font.custom("Poppins Regular", size: 14)
        static let bold40 = Font.custom("Poppins Bold", size: 40)

        static let title = Font.system(size: 36, weight: .bold, design: .default)
        static let header = Font.system(size: 24, weight: .semibold, design: .default)
        static let subheader = Font.system(size: 18, weight: .semibold, design: .default)
        static let bodyBold = Font.system(size: 16, weight: .semibold, design: .default)
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        static let caption = Font.system(size: 12, weight: .regular, design: .default)
        static let navBarTitle = Font.system(size: 24, weight: .regular, design: .default)
    }

}


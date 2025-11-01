//
//  DesignConstants.swift
//  Center
//
//  Created by Jay on 10/31/25.
//

import SwiftUI

struct DesignConstants {
    
    enum Colors {
        
        static let primary = Color(hex: 0x222222)
        static let tertiary = Color(hex: 0x2D2D2D)
        static let secondary = Color(hex: 0x7D8288)
        static let iconInactive = Color(hex: 0xE1E1E1)
        static let stroke = Color(hex: 0xE1E1E1)
        static let wash = Color(hex: 0xF4F4F4)
        static let white = Color(hex: 0xFFFFFF)
        static let tint = Color(hex: 0xE1E1E1)
        
        static let hustleGreen = Color(hex: 0x004346)
        static let accentGreen = Color(hex: 0xD5EFB4)
        
        
    }
    
    enum Fonts {
        
        //Header
        static let h1 = Font.custom("InstrumentSans-Medium", size: 36)
        static let h2 = Font.custom("InstrumentSans-Medium", size: 24)
        static let h3 = Font.custom("InstrumentSans-Bold", size: 18)
        
        //Body
        static let body1 = Font.custom("InstrumentSans-Regular", size: 18)
        static let body2 = Font.custom("InstrumentSans-Regular", size: 16)

        //Title
        static let title1 = Font.custom("HelveticaNeue-Bold", size: 24)
        static let title2 = Font.custom("HelveticaNeue-Medium", size: 16)
        static let title3 = Font.custom("HelveticaNeue-Medium", size: 14)
        static let title4 = Font.custom("HelveticaNeue", size: 14)
        static let subtitle1 = Font.custom("HelveticaNeue", size: 12)
    }
    
    enum Spacing {
        
    }
}

//        → InstrumentSans-Regular
//        → InstrumentSans-Bold
//        → InstrumentSans-BoldItalic
//        → HelveticaNeue
//        → HelveticaNeue-Roman
//        → HelveticaNeue-Italic
//        → HelveticaNeue-UltraLight
//        → HelveticaNeue-UltraLightItalic
//        → HelveticaNeue-Thin
//        → HelveticaNeue-ThinItalic
//        → HelveticaNeue-Light
//        → HelveticaNeue-LightItalic
//        → HelveticaNeue-Medium
//        → HelveticaNeue-MediumItalic
//        → HelveticaNeue-Bold
//        → HelveticaNeue-BoldItalic
//        → HelveticaNeue-CondensedBold
//        → HelveticaNeue-CondensedBlack

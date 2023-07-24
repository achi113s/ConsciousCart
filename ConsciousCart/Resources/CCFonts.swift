//
//  CCFonts.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/17/23.
//

import UIKit

enum CCTextStyle {
    case largeTitle
    case title
    case title2
    case title3
    case body
    case headline
    case subheadline
    case subheadline2
    case footnote
    case footnote2
    case caption
    case caption2
    case bold
    case semibold
    case regular
}

extension UIFont {
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: size)
    }
    
    static func ccFont(textStyle: CCTextStyle) -> UIFont {
        let fontName = UIFont.textStyleWeight(for: textStyle)
        let fontSize = UIFont.textStyleSize(for: textStyle)
        
        let font = UIFont.customFont(name: fontName, size: fontSize)
        
        return font
    }
    
    static func ccFont(textStyle: CCTextStyle, fontSize: CGFloat) -> UIFont {
        let fontName = UIFont.textStyleWeight(for: textStyle)
        
        let font = UIFont.customFont(name: fontName, size: fontSize)
        
        return font
    }
    
    private static func textStyleSize(for textStyle: CCTextStyle) -> CGFloat {
        switch textStyle {
        case .largeTitle:
            return 34
        case .title:
            return 28
        case .title2:
            return 24
        case .title3:
            return 20
        case .body:
            return 17
        case .headline:
            return 17
        case .subheadline:
            return 15
        case .subheadline2:
            return 15
        case .footnote:
            return 13
        case .footnote2:
            return 13
        case .caption:
            return 12
        case .caption2:
            return 12
        case .bold:
            return 17
        case .regular:
            return 17
        case .semibold:
            return 17
        }
    }
    
    private static func textStyleWeight(for textStyle: CCTextStyle) -> String {
        switch textStyle {
        case .largeTitle, .title, .title2, .title3, .bold:
            return "Nunito-Bold"
        case .body, .subheadline, .footnote, .caption, .regular:
            return "Nunito-Regular"
        case .headline, .subheadline2, .footnote2, .caption2, .semibold:
            return "Nunito-SemiBold"
        }
    }
}

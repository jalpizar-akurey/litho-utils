//
//  CodableLabelStyle.swift
//  LithoUtils
//
//  Created by Remmington Damper on 1/12/22.
//

import Foundation
import UIKit
import Prelude
import LithoOperators

open class CodableLabelStyle : CodableViewStyle {
    open var font: CodableFont?
    open var textColor: String?
    open var labelShadowColor: String?
    open var lineHeightMultiple: CGFloat?
    
    public init(backgroundColorHex: String? = nil, tintColorHex: String? = nil, isHidden: Bool? = nil, isOpaque: Bool? = nil, clipsToBounds: Bool? = nil, alpha: CGFloat? = nil, cornerRadius: CGFloat? = nil, isRounded: Bool? = nil, borderWidth: CGFloat? = nil, borderColorHex: String? = nil, shadowColorHex: String? = nil, shadowRadius: CGFloat? = nil, shadowOpacity: Float? = nil, font: CodableFont? = nil, textColor: String? = nil, labelShadowColor: String? = nil, lineHeightMultiple: CGFloat? = nil) {
        self.font = font
        self.textColor = textColor
        self.labelShadowColor = labelShadowColor
        self.lineHeightMultiple = lineHeightMultiple
        super.init(backgroundColorHex: backgroundColorHex, tintColorHex: tintColorHex, isHidden: isHidden, isOpaque: isOpaque, clipsToBounds: clipsToBounds, alpha: alpha, cornerRadius: cornerRadius, isRounded: isRounded, borderWidth: borderWidth, borderColorHex: borderColorHex, shadowColorHex: shadowColorHex, shadowRadius: shadowRadius, shadowOpacity: shadowOpacity)
    }
    
    private enum CodingKeys: String, CodingKey {
        case font, textColor, labelShadowColor, lineHeightMultiple
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        textColor = try container.decode(String.self, forKey: .textColor)
        labelShadowColor = try container.decode(String.self, forKey: .labelShadowColor)
        lineHeightMultiple = try container.decode(CGFloat.self, forKey: .lineHeightMultiple)
        font = try container.decode(CodableFont.self, forKey: .font)
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    
    public override func apply(to view: UIView) {
        view |> ~>styleLabelFunction(given: self)
    }
}

public func styleLabelFunction(given style: CodableLabelStyle) -> (UILabel) -> Void {
    let doNothing: (UILabel) -> Void = styleFunction(given: style)
    var result: (UILabel) -> Void = doNothing

    result <>= style.textColor |> (~>UIColor.init(hexString:) >>> (\UILabel.textColor *-> set))
    result <>= style.labelShadowColor |> (~>UIColor.init(hexString:) >>> (\UILabel.shadowColor *-> set))
    result <>= style.font?.setOnLabel
    
    return result
}

public func attributedTextSetter(given style: CodableLabelStyle) -> (UILabel, String?) -> Void {
    return { label, text in
        
    }
}

//
//  CodableButton.swift
//  LithoUtils
//
//  Created by Remmington Damper on 1/9/22.
//

import Foundation
import LithoOperators
import Prelude
import UIKit

open class CodableButtonStyle: CodableViewStyle {
    open var titleColor: String?
    open var titleShadowColor: String?
    open var titleAndImageTintColor: String?
    open var font: CodableFont?
    
    public init(backgroundColorHex: String? = nil, tintColorHex: String? = nil, isHidden: Bool? = nil, isOpaque: Bool? = nil, clipsToBounds: Bool? = nil, alpha: CGFloat? = nil, cornerRadius: CGFloat? = nil, borderWidth: CGFloat? = nil, borderColorHex: String? = nil, shadowColorHex: String? = nil, shadowRadius: CGFloat? = nil, shadowOpacity: Float? = nil, titleColor: String? = nil, titleShadowColor: String? = nil, titleAndImageTintColor: String? = nil, font: CodableFont? = nil) {
        self.titleColor = titleColor
        self.titleShadowColor = titleShadowColor
        self.titleAndImageTintColor = titleAndImageTintColor
        self.font = font
        super.init(backgroundColorHex: backgroundColorHex, tintColorHex: tintColorHex, isHidden: isHidden, isOpaque: isOpaque, clipsToBounds: clipsToBounds, alpha: alpha, cornerRadius: cornerRadius, borderWidth: borderWidth, borderColorHex: borderColorHex, shadowColorHex: shadowColorHex, shadowRadius: shadowRadius, shadowOpacity: shadowOpacity)
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    public override func apply(to view: UIView) {
        view |> ~>styleButtonFunction(given: self)
    }
}

public func styleButtonFunction(given style: CodableButtonStyle) -> (UIButton) -> Void {
    let doNothing: (UIButton) -> Void = styleFunction(given: style)
    var result: (UIButton) -> Void = doNothing
    result <>= style.titleColor |> (~>UIColor.init(hexString:) >?> buttonTitleColorSetter(color:))
   result <>= style.titleShadowColor |> (~>UIColor.init(hexString:) >?> buttonTitleColorSetter(color:))
    result <>= style.font?.setOnButton
    result <>= style.titleAndImageTintColor |> (~>UIColor.init(hexString:) >>> (\UIButton.tintColor *-> set))
  return result
}

func buttonTitleColorSetter(color: UIColor) -> (UIButton) -> Void {
    return {
        button in
        button.setTitleColor(color, for: .normal)
    }
}
func buttonTitleShadowColorSetter(color: UIColor) -> (UIButton) -> Void {
    return {
        button in
        button.setTitleShadowColor(color, for: .normal)
    }
}

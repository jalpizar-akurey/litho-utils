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
import LithoStrings

open class CodableButtonStyle: CodableViewStyleProtocol, Codable {
    public var backgroundColorHex: String?
    public var tintColorHex: String?
    public var isHidden: Bool?
    public var isOpaque: Bool?
    public var clipsToBounds: Bool?
    public var alpha: CGFloat?
    public var cornerRadius: CGFloat?
    public var isRounded: Bool?
    public var borderWidth: CGFloat?
    public var borderColorHex: String?
    public var shadowColorHex: String?
    public var shadowRadius: CGFloat?
    public var shadowOpacity: Float?
    
    open var titleColor: String?
    open var titleShadowColor: String?
    open var font: CodableFont?
    
    public init() {}
    
    public func apply(to view: UIView?) {
        view |> ~>styleButtonFunction(given: self)
    }
    
    public func apply(to view: UIView?, withTitle title: String?) {
        view |> ~>styleButtonWithTitle(given: self, with: title)
    }
}

public func styleButtonFunction(given style: CodableButtonStyle) -> (UIButton?) -> Void {
    let doNothing: (UIButton?) -> Void = styleFunction(given: style)
    var result: (UIButton?) -> Void = doNothing
    result <>= style.titleColor |> (~>UIColor.init(hexString:) >?> buttonTitleColorSetter(color:))
    result <>= style.titleShadowColor |> (~>UIColor.init(hexString:) >?> buttonTitleColorSetter(color:))
    result <>= style.font?.setOnButton
  return result
}

public func styleButtonWithTitle(given style: CodableButtonStyle, with title: String?) -> (UIButton?) -> Void {
    var result: (UIButton?) -> Void = styleFunction(given: style)
    result <>= style.titleShadowColor |> (~>UIColor.init(hexString:) >?> buttonTitleColorSetter(color:))
    result <>= (title -*> attributedStringSetter(given: style))
    return result
}

func buttonTitleColorSetter(color: UIColor) -> (UIButton?) -> Void {
    return { $0?.setTitleColor(color, for: .normal) }
}
func buttonTitleShadowColorSetter(color: UIColor) -> (UIButton?) -> Void {
    return { $0?.setTitleShadowColor(color, for: .normal) }
}

func attributedStringSetter(given style: CodableButtonStyle) -> (UIButton?, String?) -> Void {
    return { button, title in
        let attributed = convertToMutableString(fromRegularString: title ?? "")
        style.font?.font() ?> (attributed -*> setFontAttributes)
        style.titleColor ?> (UIColor.init(hexString:) >?> (attributed -*> setForegroundColorAttributes))
        button?.setAttributedTitle(attributed, for: .normal)
    }
}

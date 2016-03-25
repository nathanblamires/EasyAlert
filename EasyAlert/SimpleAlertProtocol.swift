
/**
 * EasyAlert
 * EAControllerProtocol, EAActionProtocol, EACustomActionProtocol, EAStandardActionProtocol, EAType, EAAnimationStyle
 *
 * Copyright (c) 2016 Nathan Blamires
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

import UIKit

protocol EAControllerProtocol {
    
    // setup
    init(title: String?, message: String?, type: EAType)
    
    // configuration
    func addAction(action: EAActionProtocol)
    func updateTitleText(text: String)
    func updateMessageText(text: String)
    func updateAnimationStyle(show show: EAAnimationStyle, dismiss: EAAnimationStyle)
    
    // styling
    func updateStatusBarStyle(style: UIStatusBarStyle)
    func updateFonts(titleFont: UIFont, messageFont: UIFont)
    func updateBackColour(backColour: UIColor, itemColour: UIColor)
    func updateCornerRadius(cornerRadius: CGFloat)
    func enableBorder(enable: Bool)
    func enableShadow(enable: Bool)
}

// MARK: Actions

protocol EAActionProtocol {
    var handler: (Void)->(Void)? {get}
    var button: UIButton {get}
}

protocol EACustomActionProtocol: EAActionProtocol {
    
    // setup
    init(button: UIButton, handler: (Void)->(Void))
    
    // configuration
    func updateButton(button: UIButton)
    func updateHandler(handler: (Void)->(Void))
}

protocol EAStandardActionProtocol: EAActionProtocol {
    
    // setup
    init(title: String, subtitle: String?, icon: UIImage?, handler: (Void)->(Void))
    
    // configuration
    func updateHandler(handler: (Void)->(Void))
    func updateTitleText(text: String)
    func updateSubtitleText(text: String)
    func updateIconImage(image: UIImage)
    
    // styling
    func updateColours(backColour: UIColor, itemColour: UIColor)
    func updateFonts(titleFont: UIFont, subtitleFont: UIFont)
    func updateCornerRadius(cornerRadius: CGFloat, borderWidth: CGFloat)
    
}

// MARK: Data Types

enum EAType: Int {
    case ActionSheet = 0
    case Alert = 1
}

enum EAAnimationStyle: Int {
    case Appear = 0
    case SlideUp = 1
    case SlideDown = 2
}
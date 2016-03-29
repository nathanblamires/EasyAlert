
/**
 * EasyAlert
 * SimpleAlertController
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

class EAController: UIViewController, EAControllerProtocol {

    // view properties
    private let backView: UIView = UIView()
    private var alertView: UIView = UIView()
    private let alertScrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private var titleLabel: UILabel = UILabel()
    private var messageLabel: UILabel = UILabel()
    
    // data properties
    private var alertTitle: String?
    private var alertMessage: String?
    private var alertType: EAType = .Alert
    private var alertShowAnimationStyle: EAAnimationStyle = .Appear
    private var alertDismissAnimationStyle: EAAnimationStyle = .Appear
    private var actions: [EAActionProtocol] = Array()
    
    // default values
    private var defaultAlertTitle: String = "Alert"
    private var defaultActionSheetTitle: String = "Actions"
    private var slideAnimationTime: Double = 0.3
    private var appearAnimationTime: Double = 0.15
    private let buttonHeight: CGFloat = 45
    private let borderWidth: CGFloat = 1
    
    // default style values
    private var backgroundColour: UIColor = UIColor.whiteColor()
    private var itemColour: UIColor = UIColor.blackColor()
    private var cornerRadius: CGFloat = 8
    private var shadowEnableld: Bool = true
    private var borderEnabled: Bool = true
    private var titleFont: UIFont = UIFont(name: "HelveticaNeue-Medium", size: 20)!
    private var messageFont: UIFont = UIFont(name: "HelveticaNeue", size: 14)!
    private var statusBarColour: UIStatusBarStyle = .Default
    
    // state tracking
    private var alertPresented: Bool = false
    
    // MARK: Setup Methods
    
    required init(title: String?, message: String?, type: EAType){
        
        // set data
        self.alertTitle = title
        self.alertMessage = message
        self.alertType = type
        
        super.init(nibName: nil, bundle: nil)
        
        // enable display over previous vc
        self.view.backgroundColor = .clearColor()
        self.modalPresentationStyle = .OverCurrentContext
        
        self.updateStyling()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAction(action: EAActionProtocol){
        self.actions.append(action)
    }
    
    // MARK: Content Setting
    
    func updateTitleText(text: String){
        self.alertTitle = text
    }
    
    func updateMessageText(text: String){
        self.alertMessage = text
    }
    
    // MARK: Configurations
    
    func updateAnimationStyle(show show: EAAnimationStyle, dismiss: EAAnimationStyle){
        self.alertShowAnimationStyle = show
        self.alertDismissAnimationStyle = dismiss
    }
    
    // MARK: Styling
    
    func updateStatusBarStyle(style: UIStatusBarStyle){
        self.statusBarColour = style
    }
    
    func updateFonts(titleFont: UIFont, messageFont: UIFont){
        self.titleFont = titleFont
        self.messageFont = messageFont
        self.updateStyling()
    }

    func updateBackColour(backColour: UIColor, itemColour: UIColor){
        self.backgroundColour = backColour
        self.itemColour = itemColour
        self.updateStyling()
    }
    
    func updateCornerRadius(cornerRadius: CGFloat){
        self.cornerRadius = cornerRadius
        self.updateStyling()
    }
    
    func enableShadow(enable: Bool){
        self.shadowEnableld = enable
        self.updateStyling()
    }
    
    func enableBorder(enable: Bool){
        self.borderEnabled = enable
        self.updateStyling()
    }
    
    // MARK: Entry
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if(self.alertPresented == false){
            
            // make buttons dismiss view
            for action: EAActionProtocol in self.actions {
                action.button.addTarget(self, action: #selector(animateOut), forControlEvents: .TouchUpInside)
            }
            
            // setup and style
            self.alertPresented = true
            self.setupViews()

            // set title and message
            let defaultTitle = (self.alertType == .Alert) ? self.defaultAlertTitle : self.defaultActionSheetTitle
            self.titleLabel.text = (self.alertTitle == nil) ? defaultTitle : self.alertTitle!
            self.messageLabel.text = (self.alertMessage == nil) ? "" : self.alertMessage!
            
            // present
            self.animateSetup()
            self.animateIn()
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.statusBarColour
    }
    
    // Updating when view changes
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        self.alertScrollView.delaysContentTouches = (self.alertScrollView.frame.size.height < self.contentView.frame.size.height)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.alertScrollView.delaysContentTouches = (self.alertScrollView.frame.size.height < self.contentView.frame.size.height)
    }
}

// MARK: Alert Animations

extension EAController {
    
    private func animateSetup() {
        
        // change backgeround
        self.view.layoutIfNeeded()
        self.backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        // position alert just out of view
        if (self.alertShowAnimationStyle == .SlideUp) {
            self.alertView.frame.origin.y = self.view.frame.size.height
        } else if (self.alertShowAnimationStyle == .SlideDown){
            self.alertView.frame.origin.y = -self.alertView.frame.size.height
        } else {
            self.alertView.transform = CGAffineTransformMakeScale(0.85,0.85)
            self.alertView.alpha = 0
        }
    }
    
    private func animateIn() {
        
        let time = (self.alertShowAnimationStyle == .Appear) ? self.appearAnimationTime : self.slideAnimationTime
        UIView.animateWithDuration(time, animations: { () -> Void in
            
            // change backgeround
            self.backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            
            // move the view
            if (self.alertShowAnimationStyle == .SlideUp || self.alertShowAnimationStyle == .SlideDown) && self.alertType == .Alert {
                self.alertView.frame.origin.y = (self.view.frame.size.height - self.alertView.frame.size.height) / 2
            } else if (self.alertType == .Alert) {
                self.alertView.transform = CGAffineTransformIdentity
                self.alertView.alpha = 1
            } else if (self.alertType == .ActionSheet){
                self.alertView.frame.origin.y = self.view.frame.size.height - self.alertView.frame.size.height + self.borderWidth
            }

        }) { (finished) -> Void in
            self.view.layoutIfNeeded()
            self.alertScrollView.delaysContentTouches = (self.alertScrollView.frame.size.height < self.contentView.frame.size.height)
        }
    }
    
    internal func animateOut() {
        
        let time = (self.alertDismissAnimationStyle == .Appear) ? self.appearAnimationTime : self.slideAnimationTime
        UIView.animateWithDuration(time, animations: { () -> Void in
            
            // change backgeround
            self.backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

            // move the view
            if (self.alertDismissAnimationStyle == .SlideDown) {
                self.alertView.frame.origin.y = self.view.frame.size.height
            } else if (self.alertDismissAnimationStyle == .SlideUp){
                self.alertView.frame.origin.y = -self.alertView.frame.size.height
            } else {
                self.alertView.transform = CGAffineTransformMakeScale(0.85,0.85)
                self.alertView.alpha = 0
            }
            
        }) { (finished) -> Void in
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
}

// MARK: Alert View Styling

extension EAController {
    
    private func updateStyling(){

        // back view styling
        self.backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        // alert view styling
        self.alertView.backgroundColor = self.backgroundColour
        self.alertView.layer.cornerRadius = (self.alertType == .Alert) ? self.cornerRadius : 0
        self.alertView.clipsToBounds = true
        self.alertView.layer.borderWidth = (borderEnabled) ? 1 : 0
        self.alertView.layer.borderColor = self.itemColour.CGColor
        
        // title label styling
        self.titleLabel.font = self.titleFont
        self.titleLabel.textAlignment = .Center
        self.titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        self.titleLabel.textColor = self.itemColour
        
        // message label styling
        self.messageLabel.font = self.messageFont
        self.messageLabel.numberOfLines = 0
        self.messageLabel.textAlignment = .Center
        self.messageLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        self.messageLabel.textColor = self.itemColour
        
        // shadow
        self.alertView.layer.masksToBounds = false;
        self.alertView.layer.shadowOffset = (self.alertType == .Alert) ? CGSizeMake(0, 0) : CGSizeMake(0, -5);
        self.alertView.layer.shadowRadius = 5;
        self.alertView.layer.shadowColor = UIColor.blackColor().CGColor
        self.alertView.layer.shadowOpacity = (self.shadowEnableld) ? 0.2 : 0;
    }
}

// MARK: Alert View Creation

extension EAController {

    // MARK: Setup

    private func setupViews(){
        
        // mandatory settings
        if self.alertType == .ActionSheet{
            self.alertShowAnimationStyle = .SlideUp
            self.alertDismissAnimationStyle = .SlideDown
        }
        
        // create the views
        self.setupBackView()
        self.setupAlertView()
        self.setupScrollView()
        self.setupLabels()
        self.setupButtons()
    }
    
    private func setupBackView(){

        // add constraints
        self.view.addSubview(self.backView)
        self.backView.translatesAutoresizingMaskIntoConstraints = false
        for attribute: NSLayoutAttribute in [.Leading, .Trailing, .Top, .Bottom]{
            self.view.addConstraint(NSLayoutConstraint(item: self.backView, attribute: attribute, relatedBy: .Equal, toItem: self.view, attribute: attribute, multiplier: 1, constant: 0))
        }
        self.backView.userInteractionEnabled = true

        // tap empty space to dismiss for action bar
        if self.alertType == .ActionSheet || self.actions.count == 0 {
            self.backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))
        }
    }
    
    private func setupAlertView(){
    
        // add constraints
        self.view.addSubview(self.alertView)
        self.alertView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: self.alertView, attribute: .Height, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 110))
        self.view.addConstraint(NSLayoutConstraint(item: self.alertView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.alertView, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: self.view, attribute: .Top, multiplier: 1, constant: 30))
        self.view.addConstraint(NSLayoutConstraint(item: self.alertView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.alertView, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: -30))
        
        // constraints for specific alert type
        if self.alertType == .Alert {
            self.view.addConstraint(NSLayoutConstraint(item: self.alertView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 300))
        } else {
            self.view.addConstraint(NSLayoutConstraint(item: self.alertView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: self.borderWidth * 2))
        }
    }
    
    private func setupScrollView(){

        // add scrollview constraints
        self.alertView.addSubview(self.alertScrollView)
        self.alertScrollView.translatesAutoresizingMaskIntoConstraints = false
        for attribute: NSLayoutAttribute in [.Leading, .Trailing, .Top, .Bottom]{
            self.alertView.addConstraint(NSLayoutConstraint(item: self.alertScrollView, attribute: attribute, relatedBy: .Equal, toItem: self.alertView, attribute: attribute, multiplier: 1, constant: 0))
        }
    
        // add contentview constraints
        self.alertScrollView.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        for attribute: NSLayoutAttribute in [.Leading, .Trailing, .Top, .Bottom]{
            self.alertScrollView.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: attribute, relatedBy: .Equal, toItem: self.alertScrollView, attribute: attribute, multiplier: 1, constant: 0))
        }
        self.alertScrollView.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: .Width, relatedBy: .Equal, toItem: self.alertScrollView, attribute: .Width, multiplier: 1, constant: 0))
        self.alertScrollView.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: .Height, relatedBy: .GreaterThanOrEqual, toItem: self.alertScrollView, attribute: .Height, multiplier: 1, constant: 0))
    }
    
    private func setupLabels(){
        
        // title constraints
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 35))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .Leading, relatedBy: .Equal, toItem: self.contentView, attribute: .Leading, multiplier: 1, constant: 20))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self.contentView, attribute: .Trailing, multiplier: 1, constant: -20))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .Top, relatedBy: .Equal, toItem: self.contentView, attribute: .Top, multiplier: 1, constant: 10))
        
        // message constraints
        self.contentView.addSubview(self.messageLabel)
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraint(NSLayoutConstraint(item: self.messageLabel, attribute: .Leading, relatedBy: .Equal, toItem: self.contentView, attribute: .Leading, multiplier: 1, constant: 20))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.messageLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self.contentView, attribute: .Trailing, multiplier: 1, constant: -20))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.messageLabel, attribute: .Top, relatedBy: .Equal, toItem: self.titleLabel, attribute: .Bottom, multiplier: 1, constant: 5))
    }
    
    private func setupButtons(){
        if(self.actions.count == 2 && self.alertType == .Alert){
            self.setupTwoButtonAlert()
        } else {
            self.setupMultiButtonAlert()
        }
    }

    private func setupTwoButtonAlert(){
        
        let action1: EAActionProtocol = self.actions[0]
        let action2: EAActionProtocol = self.actions[1]
        self.contentView.addSubview(action1.button)
        self.contentView.addSubview(action2.button)
        
        for x in 0...1 {
            
            let action: EAActionProtocol = self.actions[x]
            let button = action.button

            // add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: self.messageLabel, attribute: .Bottom, multiplier: 1, constant: 15))
            self.contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: self.contentView, attribute: .Bottom, multiplier: 1, constant: -15))
            self.contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.buttonHeight))
            
            // custom constraints
            if x == 0 {
                self.contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: self.contentView, attribute: .Leading, multiplier: 1, constant: 15))
            } else {
                self.contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: action1.button, attribute: .Trailing, multiplier: 1, constant: 10))
                self.contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .Trailing, relatedBy: .Equal, toItem: self.contentView, attribute: .Trailing, multiplier: 1, constant: -15))
                self.contentView.addConstraint(NSLayoutConstraint(item: action1.button, attribute: .Width, relatedBy: .Equal, toItem: action2.button, attribute: .Width, multiplier: 1, constant: 0))
            }
        }
    }
    
    private func setupMultiButtonAlert(){
        
        var lastButtonOptional: UIButton?
        
        for x in 0..<self.actions.count {
            
            let action: EAActionProtocol = self.actions[x]
            let button = action.button
            
            // add constraints
            self.contentView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.buttonHeight))
            self.contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: self.contentView, attribute: .Leading, multiplier: 1, constant: 15))
            self.contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .Trailing, relatedBy: .Equal, toItem: self.contentView, attribute: .Trailing, multiplier: 1, constant: -15))
            
            // top constraint to last button or message label (if first button)
            let relativeView: UIView = (lastButtonOptional == nil) ? self.messageLabel : lastButtonOptional!
            let constantValue: CGFloat = (lastButtonOptional == nil) ? 15 : 8
            self.contentView.addConstraint(NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: relativeView, attribute: .Bottom, multiplier: 1, constant: constantValue))
            lastButtonOptional = button
        }
        
        // last bottom constraint
        if let lastButton = lastButtonOptional {
            self.contentView.addConstraint(NSLayoutConstraint(item: lastButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.contentView, attribute: .Bottom, multiplier: 1, constant: -15))
        }
    }
}

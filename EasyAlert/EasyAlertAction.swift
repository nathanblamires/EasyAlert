
/**
 * EasyAlert
 * EAStandardAction, EACustomAction, EAStandardButton
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

// MARK Standard Action

class EAStandardAction: EAStandardActionProtocol {
    
    private(set) var handler: (Void)->(Void)?
    private(set) var button: UIButton = UIButton()
    
    // Setup
    
    required init(){
        fatalError("init() has not been implemented")
    }
    
    required init(title: String, subtitle: String?, icon: UIImage?, handler: (Void)->(Void)){
        self.handler = handler
        self.button = EAStandardButton(title: title, subtitle: subtitle, icon: icon) as UIButton
        self.button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
    }
    
    // Configuration
    
    func updateHandler(handler: (Void)->(Void)){
        self.handler = handler
    }
    
    func updateTitleText(text: String){
        let standardButton = self.button as! EAStandardButton
        standardButton.updateTitle(text)
    }
    
    func updateSubtitleText(text: String){
        let standardButton = self.button as! EAStandardButton
        standardButton.updateSubtitle(text)
    }
    
    func updateIconImage(image: UIImage){
        let standardButton = self.button as! EAStandardButton
        standardButton.updateIcon(image)
    }
    
    // Styling
    
    func updateColours(backColour: UIColor, itemColour: UIColor){
        let standardButton = self.button as! EAStandardButton
        standardButton.updateColours(backColour, itemColour:itemColour)
    }
    
    func updateFonts(titleFont: UIFont, subtitleFont: UIFont){
        let standardButton = self.button as! EAStandardButton
        standardButton.updateFonts(titleFont, subtitleFont:subtitleFont)
    }
    
    func updateCornerRadius(cornerRadius: CGFloat, borderWidth: CGFloat){
        let standardButton = self.button as! EAStandardButton
        standardButton.updateCornerRadius(cornerRadius, borderWidth:borderWidth)
    }
    
    // Other
    
    @objc internal func buttonAction(){
        self.handler()
    }
}

// MARK Custom Action

class EACustomAction: EACustomActionProtocol {
    
    private(set) var handler: (Void)->(Void)?
    private(set) var button: UIButton = UIButton()
    
    // Setup
    
    required init(){
        fatalError("init() has not been implemented")
    }
    
    required init(button: UIButton, handler: (Void)->(Void)){
        self.handler = handler
        self.button = button
        self.button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
    }
    
    // Configuration
    
    func updateButton(button: UIButton){
        self.button = button
    }
    
    func updateHandler(handler: (Void)->(Void)){
        self.handler = handler
    }
    
    // Other
    
    @objc internal func buttonAction(){
        self.handler()
    }
}

// MARK Standard Button

class EAStandardButton: UIButton {
    
    // views
    private var contentView: UIView = UIView()
    private var mainLabel: UILabel = UILabel()
    private var supportingLabel: UILabel = UILabel()
    private var iconImageView: UIImageView = UIImageView()
    
    // flags
    private var supportingLabelPresent: Bool = false
    private var iconImageViewPresent: Bool = false
    
    // standard colours
    private var backColour: UIColor = UIColor.whiteColor()
    private var itemColour: UIColor = UIColor.blackColor()
    private var cornerRadius: CGFloat = 8
    private var borderWidth: CGFloat = 1
    
    required init(title: String, subtitle: String?, icon: UIImage?){
        super.init(frame: CGRectMake(0, 0, 0, 0))
        self.updateContent(title, subtitle: subtitle, icon: icon)
        self.updateViewInButton()
        self.defaultStyling()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Update Methods
    
    func updateTitle(title: String){
        self.updateContent(title, subtitle: supportingLabel.text, icon: iconImageView.image)
        self.updateViewInButton()
    }
    
    func updateSubtitle(subtitle: String){
        self.updateContent(self.mainLabel.text!, subtitle: subtitle, icon: iconImageView.image)
        self.updateViewInButton()
    }
    
    func updateIcon(image: UIImage){
        self.updateContent(self.mainLabel.text!, subtitle: supportingLabel.text, icon: image)
        self.updateViewInButton()
    }
    
    // MARK: Styling Methods
    
    func updateColours(backColour: UIColor, itemColour: UIColor){
        self.backColour = backColour
        self.itemColour = itemColour
        self.updateButtonColours()
    }
    
    func updateFonts(titleFont: UIFont, subtitleFont: UIFont){
        self.mainLabel.font = titleFont
        self.supportingLabel.font = subtitleFont
    }
    
    func updateCornerRadius(cornerRadius: CGFloat, borderWidth: CGFloat){
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.updateButtonColours()
    }
    
    // MARK: Private Update Methods
    
    private func updateContent(title: String, subtitle: String?, icon: UIImage?){
        
        // flags for tracking rpesent views
        self.supportingLabelPresent = (subtitle != nil)
        self.iconImageViewPresent = (icon != nil)
        
        // set content
        self.mainLabel.text = title
        self.supportingLabel.text = (self.supportingLabelPresent) ? subtitle! : ""
        self.iconImageView.image = (self.iconImageViewPresent) ? icon! : UIImage()
    }
    
    private func updateViewInButton(){
        
        // clear views
        self.removeViewsFromButton()
        
        // add the views used
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.mainLabel)
        if(self.supportingLabelPresent) { self.contentView.addSubview(self.supportingLabel) }
        if(self.iconImageViewPresent) { self.contentView.addSubview(self.iconImageView) }
        
        // appy constraints
        self.resetConstraints()
        self.setConstraints()
    }
    
    // removes all button subviews form parent
    private func removeViewsFromButton(){
        self.contentView.removeFromSuperview()
        self.mainLabel.removeFromSuperview()
        if (self.supportingLabelPresent) { self.supportingLabel.removeFromSuperview() }
        if (self.iconImageViewPresent) { self.iconImageView.removeFromSuperview() }
    }
    
    // MARK: Styling Methods
    
    // default button style
    private func defaultStyling(){
        
        // button styling
        self.titleLabel?.removeFromSuperview()
        self.clipsToBounds = true
        
        // style content
        self.contentView.backgroundColor = UIColor.clearColor()
        self.contentView.userInteractionEnabled = false
        
        // style main label
        self.mainLabel.textAlignment = .Center
        self.mainLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        
        // style supporting label
        self.supportingLabel.textAlignment = .Center
        self.supportingLabel.font = UIFont(name: "HelveticaNeue", size: 10)
        
        // style image view
        self.updateButtonColours()
    }
    
    // MARK: Colour Styling Methods
    
    private func isColourBasicallyBlack(colour: UIColor) -> Bool{
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        if colour.getRed(&r, green: &g, blue: &b, alpha: &a){
            return (r < 0.1 && g < 0.1 && b < 0.1)
        }
        return false
    }
    
    private func isColourBasicallyWhite(colour: UIColor) -> Bool{
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        if colour.getRed(&r, green: &g, blue: &b, alpha: &a){
            return (r > 0.9 && g > 0.9 && b > 0.9)
        }
        return false
    }
    
    func lighterColour(colour: UIColor) -> UIColor {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        if colour.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: min(r + 0.3, 1.0), green: min(g + 0.3, 1.0), blue: min(b + 0.3, 1.0), alpha: a)
        }
        return UIColor()
    }
    
    private func updateButtonColours(){

        // get selected back colours
        var selectedBackColour: UIColor = (self.isColourBasicallyBlack(self.backColour)) ? UIColor.whiteColor() : self.lighterColour(self.backColour)
        selectedBackColour = (self.isColourBasicallyWhite(self.backColour)) ? UIColor.blackColor() : selectedBackColour
        
        // set background colour
        self.setBackgroundImage(self.colorAsImage(self.backColour), forState: .Normal)
        self.setBackgroundImage(self.colorAsImage(selectedBackColour), forState: .Highlighted)
        self.setBackgroundImage(self.colorAsImage(selectedBackColour), forState: .Selected)
        self.setBackgroundImage(self.colorAsImage(UIColor.grayColor()), forState: .Disabled)
        
        // set item colour
        self.layer.cornerRadius = self.cornerRadius
        self.layer.borderColor = self.itemColour.CGColor
        self.layer.borderWidth = 1.0
        self.mainLabel.textColor = self.itemColour
        self.supportingLabel.textColor = self.itemColour
        self.iconImageView.tintColor = self.itemColour
    }
    
    override var highlighted: Bool {
        didSet {
            
            // get selected item colour
            var selectedItemColour: UIColor = (self.isColourBasicallyBlack(self.backColour)) ? UIColor.blackColor() : self.itemColour
            selectedItemColour = (self.isColourBasicallyWhite(self.backColour)) ? UIColor.whiteColor() : selectedItemColour
            let colour = (highlighted) ? selectedItemColour : self.itemColour
            
            // apply to views
            self.layer.borderColor = colour.CGColor
            self.layer.borderWidth = 1.0
            self.mainLabel.textColor = colour
            self.supportingLabel.textColor = colour
            self.iconImageView.tintColor = colour
        }
    }
    
    // MARK: Autolayout Setup
    
    // add constraints
    private func setConstraints(){
        self.setupContentView()
        self.setupMainLabel()
        if (self.supportingLabelPresent) { self.setupSupportingLabel() }
        if (self.iconImageViewPresent) { self.setupIconImage() }
    }
    
    // remove all constriants
    private func resetConstraints(){
        self.contentView.removeConstraints(self.contentView.constraints)
        self.mainLabel.removeConstraints(self.mainLabel.constraints)
        self.supportingLabel.removeConstraints(self.supportingLabel.constraints)
        self.iconImageView.removeConstraints(self.iconImageView.constraints)
    }
    
    private func setupContentView(){
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        for attribute: NSLayoutAttribute in [.Leading, .Trailing, .Top, .Bottom]{
            self.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: attribute, relatedBy: .Equal, toItem: self, attribute: attribute, multiplier: 1, constant: 0))
        }
    }
    
    private func setupMainLabel(){
        
        // universal constraints
        self.mainLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraint(NSLayoutConstraint(item: self.mainLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self.contentView, attribute: .Trailing, multiplier: 1, constant: -5))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.mainLabel, attribute: .Top, relatedBy: .Equal, toItem: self.contentView, attribute: .Top, multiplier: 1, constant: 5))
        
        // left config dependent constraints
        let tuple:(view: UIView, attr: NSLayoutAttribute) = (self.iconImageViewPresent) ? (self.iconImageView, .Trailing) : (self.contentView, .Leading)
        self.contentView.addConstraint(NSLayoutConstraint(item: self.mainLabel, attribute: .Leading, relatedBy: .Equal, toItem: tuple.view, attribute: tuple.attr, multiplier: 1, constant: 5))
        
        // bottom config dependent constraints
        if self.supportingLabelPresent {
            self.contentView.addConstraint(NSLayoutConstraint(item: self.mainLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self.supportingLabel, attribute: .Top, multiplier: 1, constant: 0))
            self.contentView.addConstraint(NSLayoutConstraint(item: self.mainLabel, attribute: .Height, relatedBy: .Equal, toItem: self.supportingLabel, attribute: .Height, multiplier: 1, constant: 5))
        } else {
            self.contentView.addConstraint(NSLayoutConstraint(item: self.mainLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self.contentView, attribute: .Bottom, multiplier: 1, constant: -5))
        }
    }
    
    private func setupSupportingLabel(){
        
        // universal constraints
        self.supportingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraint(NSLayoutConstraint(item: self.supportingLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self.contentView, attribute: .Trailing, multiplier: 1, constant: -5))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.supportingLabel, attribute: .Top, relatedBy: .Equal, toItem: self.mainLabel, attribute: .Bottom, multiplier: 1, constant: 5))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.supportingLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self.contentView, attribute: .Bottom, multiplier: 1, constant: -5))
        
        // config dependent constraints
        if self.iconImageViewPresent {
            self.contentView.addConstraint(NSLayoutConstraint(item: self.supportingLabel, attribute: .Leading, relatedBy: .Equal, toItem: self.iconImageView, attribute: .Trailing, multiplier: 1, constant: 5))
        } else {
            self.contentView.addConstraint(NSLayoutConstraint(item: self.supportingLabel, attribute: .Leading, relatedBy: .Equal, toItem: self.contentView, attribute: .Leading, multiplier: 1, constant: 5))
        }
    }
    
    private func setupIconImage(){
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraint(NSLayoutConstraint(item: self.iconImageView, attribute: .Height, relatedBy: .Equal, toItem: self.contentView, attribute: .Height, multiplier: 1, constant: -14))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.iconImageView, attribute: .Width, relatedBy: .Equal, toItem: self.contentView, attribute: .Height, multiplier: 1, constant: -14))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.iconImageView, attribute: .Leading, relatedBy: .Equal, toItem: self.contentView, attribute: .Leading, multiplier: 1, constant: 8))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.iconImageView, attribute: .CenterY, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterY, multiplier: 1, constant: 0))
    }
    
    // MARK: Helper Methods
    
    private func colorAsImage(colour: UIColor) -> UIImage {
        
        // start
        UIGraphicsBeginImageContext(CGSizeMake(1,1))
        
        // create context and form image
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, colour.CGColor)
        CGContextFillRect(context, CGRectMake(0.0, 0.0, 1.0, 1.0))
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // end
        UIGraphicsEndImageContext();
        return image;
    }
}


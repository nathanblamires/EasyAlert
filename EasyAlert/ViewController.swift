
/**
 * EasyAlert
 * ViewController
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

class ViewController: UIViewController {

    @IBOutlet weak var contextView: UIView!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var animateSegment: UISegmentedControl!
    @IBOutlet weak var colourSegment: UISegmentedControl!
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var buttonStepper: UIStepper!
    @IBOutlet weak var showAlertButton: UIButton!
    @IBOutlet weak var shadowToggle: UISwitch!
    @IBOutlet weak var borderToggle: UISwitch!
    private var numberOfButtons: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonStepper.minimumValue = Double(self.numberOfButtons)
        self.buttonStepper.maximumValue = 20
        self.buttonLabel.text = "Buttons: \(self.numberOfButtons)"
        self.showAlertButton.layer.cornerRadius = 8
    }
    
    @IBAction func buttonStepperChanged() {
        self.numberOfButtons = Int(buttonStepper.value)
        self.buttonLabel.text = "Buttons: \(self.numberOfButtons)"
    }
    
    @IBAction func showAlertButtonSelected() {
    
        // create
        let alertType: EAType = (typeSegment.selectedSegmentIndex == 0) ? .Alert : .ActionSheet
        let alert = EAController(title: "The Alert Title", message: "Here is a message about this particular alert message.", type: alertType)
        alert.updateStatusBarStyle(.LightContent)

        // set the animation
        var inAnimation: EAAnimationStyle = .Appear
        var outAnimation: EAAnimationStyle = .Appear
        if self.animateSegment.selectedSegmentIndex == 1 {
            inAnimation = .SlideUp
            outAnimation = .SlideDown
        } else if self.animateSegment.selectedSegmentIndex == 2{
            inAnimation = .SlideDown
            outAnimation = .SlideUp
        }
        alert.updateAnimationStyle(show: inAnimation, dismiss: outAnimation)
        
        // shadow and border
        alert.enableShadow(self.shadowToggle.on)
        alert.enableBorder(self.borderToggle.on)

        // add colours
        switch self.colourSegment.selectedSegmentIndex {
            case 0: alert.updateBackColour(UIColor.whiteColor(), itemColour: UIColor.blackColor())
            case 1: alert.updateBackColour(UIColor.blackColor(), itemColour: UIColor.whiteColor())
            case 2: alert.updateBackColour(UIColor.redColor(), itemColour: UIColor.whiteColor())
            case 3: alert.updateBackColour(UIColor.blueColor(), itemColour: UIColor.whiteColor())
            default: break
        }

        // add actions
        for _ in 0..<self.numberOfButtons {
            
            let action = EAStandardAction(title: "Option", subtitle: nil, icon: nil, handler: { (Void) -> (Void) in })
            alert.addAction(action)

            switch self.colourSegment.selectedSegmentIndex {
                case 0: action.updateColours(UIColor.whiteColor(), itemColour: UIColor.blackColor())
                case 1: action.updateColours(UIColor.blackColor(), itemColour: UIColor.whiteColor())
                case 2: action.updateColours(UIColor.redColor(), itemColour: UIColor.whiteColor())
                case 3: action.updateColours(UIColor.blueColor(), itemColour: UIColor.whiteColor())
                default: break
            }
        }

        // present
        self.presentViewController(alert, animated: false, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}


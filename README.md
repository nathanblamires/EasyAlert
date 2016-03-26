# EasyAlert

EasyAlert is a simple and configurable alert framework, that allows you to easily add custom alerts and slide up menus to your swift iOS application. Unlike the standard UAlertController, EasyAlert enables complete customisation of colours, fonts, shadows, buttons and more, to make your application's alerts fit in with your preferences, style and application design.

## Samples

<img src="https://cloud.githubusercontent.com/assets/4186265/14058127/0d6eb7cc-f36b-11e5-8814-72f9b511ac5b.gif" width="225" height="400">
<img src="https://cloud.githubusercontent.com/assets/4186265/14058131/1d9ee374-f36b-11e5-8248-6d326cb5a530.gif" width="225" height="400">

## Key Advantages
* Both __Alerts__ and __Action Sheets__ supported
* Configurable alert animations (Appear, SlideUp, SlideDown)
* Simple style customisations including colours, shadows, fonts and more
* Infinite control of button behaviour and appearance
* Basic API calls make integration a breeze

## Public Calls  
  
### Alert Creation  

```
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
```

### Alert Standard Actions  

```
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
```   

### Alert Custom Actions  

```
// setup
init(button: UIButton, handler: (Void)->(Void))
    
// configuration
func updateButton(button: UIButton)
func updateHandler(handler: (Void)->(Void))
```

## Setup

Simply import the three library files (EAProtocol.swift, EAController.swift, EAAction.swift) into your project and your ready to get alerting. Follow the simple API call to create, configure and present an alert in your own application.

## Create Alert
To __create and alert__, simply call the following init method on the __EAController__ class
```init(title: String?, message: String?, type: EAType)```  
for example  
```let alert = EAController(title: "Title", message: "My message", type: alertType)```  

Once created, you can update the styling and content of your alert using its update methods.
```alert.updateTitleText("New Title")```  
```alert.updateMessageText("New Message")```  
```alert.updateAnimationStyle(show: .Appear, dismiss: .SlideDown)```   

```alert.updateStatusBarStyle(.LightContent)```   
```alert.updateFonts(titleFont, messageFont: messageFont)```  
```alert.updateBackColour(UIColor.whiteColor(), itemColour: UIColor.blackColor())```    
```alert.updateCornerRadius(5)```   
```alert.enableBorder(false)```   
```alert.enableShadow(true)```   

## Create Actions

## Present Alert

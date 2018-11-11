//
//  CalcViewController.swift
//  CalcMenuBar
//
//  Created by Scott on 11/6/18.
//  Copyright © 2018 Nutz & Boltz Productions. All rights reserved.
//

import Cocoa
import ServiceManagement

@IBDesignable class Buffers : NSObject {
	@objc dynamic var leftTerm : String
	@objc dynamic var rightTerm : String
	@objc dynamic var queue : String
	@objc dynamic var opr : Int

	override init() {
		self.queue = ""
		self.rightTerm = ""
		self.leftTerm = ""
		self.opr = 300

		super.init()
	}
}

private var myContext = 0

class CalcViewController: NSViewController {
	/* OPERATORS */
	@IBOutlet var acButton: NSButton!
	@IBOutlet var peButton: NSButton!
	@IBOutlet var percentButton: NSButton!
	@IBOutlet var multiplyButton: NSButton!
	@IBOutlet var minusButton: NSButton!
	@IBOutlet var divideButton: NSButton!
	@IBOutlet var equalButton: NSButton!
	@IBOutlet var periodButton: NSButton!
	@IBOutlet var plusButton: NSButton!

	/* NUMBERS */
	@IBOutlet var nineButton: NSButton!
	@IBOutlet var eightButton: NSButton!
	@IBOutlet var sevenButton: NSButton!
	@IBOutlet var sixButton: NSButton!
	@IBOutlet var fiveButton: NSButton!
	@IBOutlet var fourButton: NSButton!
	@IBOutlet var threeButton: NSButton!
	@IBOutlet var twoButton: NSButton!
	@IBOutlet var oneButton: NSButton!
	@IBOutlet var zeroButton: NSButton!

	// OTHER VARS
	@IBOutlet var buttons : NSMutableDictionary!
	@IBOutlet var colors : NSDictionary!
	@IBOutlet var valueLabel : ResultsTextField!
	@IBOutlet var buffers : Buffers!
	var observedQueue : NSKeyValueObservation?

	// Handler the Buffer.queue Changed Event
	func queueOfBufferChanged(change : NSKeyValueObservedChange<String>){
		self.valueLabel.stringValue = buffers.queue
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Add an observer on the Buffer.queue object
		observedQueue = observe(\.buffers.queue, options: [.new, .old]) { object, change in
			self.queueOfBufferChanged(change: change)
		}

		self.loadColors()
		self.loadButtons()

		let oKeys : NSArray = [200,201,202,203,300]
		let mKeys : NSArray = [205,206,207]
		let lKeys : NSArray = [0,1,2,3,4,5,6,7,8,9,100]

		for key in oKeys{
			let color : CGColor = self.colors.value(forKey: "orange") as! CGColor
			let button : NSButton = buttons?[key] as! NSButton
			button.layer?.backgroundColor = color
		}

		for key in mKeys{
			let color : CGColor = self.colors.value(forKey: "mdGray") as! CGColor
			let button : NSButton = buttons?[key] as! NSButton
			button.layer?.backgroundColor = color
		}

		for key in lKeys{
			let color : CGColor = self.colors.value(forKey: "ltGray") as! CGColor
			let button : NSButton = buttons?[key] as! NSButton
			button.layer?.backgroundColor = color
		}

		self.setFont(buttons!.allValues, size: 24.0)

		self.view.layer?.backgroundColor = (self.colors.value(forKey: "dkGray") as! CGColor)
		valueLabel.layer?.backgroundColor = (self.colors.value(forKey: "dkGray") as! CGColor)
		valueLabel.textColor = NSColor.white

	}

	func loadColors() {
		let orange : CGColor = NSColor.init(calibratedRed: 255/255, green: 159/255, blue: 12/255, alpha: 1).cgColor
		let ltGray : CGColor = NSColor.init(calibratedRed: 102/255, green: 88/255, blue: 85/255, alpha: 1).cgColor
		let mdGray : CGColor = NSColor.init(calibratedRed: 75/255, green: 65/255, blue: 62/255, alpha: 1).cgColor
		let dkGray : CGColor = NSColor.init(calibratedRed: 59/255, green: 51/255, blue: 49/255, alpha: 1).cgColor
		let white : CGColor = NSColor.white.cgColor

		self.colors = ["white":white,"orange":orange,"ltGray":ltGray,"mdGray":mdGray,"dkGray":dkGray]
	}

	func loadButtons() {
		let ba : Array<NSButton> = [equalButton,multiplyButton,divideButton,minusButton,plusButton,acButton,peButton,percentButton,nineButton,eightButton,sevenButton,sixButton,fiveButton,fourButton,threeButton,twoButton,oneButton,periodButton,zeroButton]

		// Make Dictionary
		self.buttons = NSMutableDictionary(capacity: 0)
		for button in ba{

			self.buttons.setObject(button, forKey: button.tag as NSCopying)
		}
	}

	func setFont(_ buttons: Array<Any>, size: CGFloat) -> Void {

		let font : NSFont = NSFont.init(name: "Helvetica Neue Light", size: size)!
		let style = NSMutableParagraphStyle()
		style.alignment = .center

		for button in buttons {
			let title : String = (button as! NSButton).title as String
			(button as! NSButton).attributedTitle = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: NSColor.white,NSAttributedString.Key.paragraphStyle:style,NSAttributedString.Key.font:font])
		}
	}

	@IBAction func numKeyClicked(_ sender: NSButton) {
		self.invertButtonBackground(sender)
		let stringValue : String = "\(sender.tag)"
		if (buffers.queue as NSString).isEqual(to: "0") {
			buffers.queue.removeLast()
		}
		buffers.queue += stringValue
	}

	@IBAction func opKeyClicked(_ sender: NSButton) {
		self.invertButtonBackground(sender)
		switch sender.tag {
			case 400:  //Delete
				if buffers.queue.count > 0 {
					buffers.queue.removeLast()
				}
				if (buffers.queue as NSString).isEqual(to: "") {
					buffers.queue = "0"
				}
			case 207: // All Clear
				buffers.opr = 207
				buffers.queue = ""
				buffers.rightTerm = ""
				buffers.leftTerm = ""
			case 200...203:
				buffers.opr = sender.tag
				buffers.leftTerm = buffers.queue
				buffers.rightTerm = ""
				buffers.queue = ""
			case 205: // Percent
				let leftTerm : Float = buffers.queue.floatNumber()
				let result = leftTerm * 0.01
				buffers.rightTerm = ""
				buffers.queue = result.description
			case 206: // Plus/Minus
				let leftTerm : Float = buffers.queue.floatNumber()
				let result = leftTerm * -1.0
				buffers.rightTerm = ""
				buffers.queue = result.description
			case 100:
				// Can't add period if it exists already
				if buffers.queue.range(of:".") == nil {
					buffers.queue += "."
				}
			default:
				// Handle math
				performMathFunction()
		}
	}

	func performMathFunction() -> Void {
		let leftTerm : Float = buffers.leftTerm.floatNumber()
		var rightTerm : Float = 0
		if buffers.rightTerm == ""{
			rightTerm = buffers.queue.floatNumber()
		}else{
			rightTerm = buffers.rightTerm.floatNumber()
		}
		var result : Float = 0
		switch buffers.opr{
		case 203: // Add
			result = leftTerm + rightTerm
		case 202: // Subtract
			result = leftTerm - rightTerm
		case 201: // Multiply
			result = leftTerm * rightTerm
		case 200: // Divide
			if leftTerm == 0 {
				result = 0
			}else{
				result = leftTerm / rightTerm
			}
		default:
			break
		}
		buffers.rightTerm = rightTerm.description
		buffers.leftTerm = result.description
		buffers.queue = result.description
	}

	@IBAction func invertButtonBackground(_ sender: NSButton) {
		let button : NSButton = self.buttonByTag(tag: sender.tag)
		if button.tag != -1 {
			let color : CGColor = (button.layer?.backgroundColor)!
			let invertedColor : CGColor = NSColor.invertedColor(color: color)
			button.layer?.backgroundColor = invertedColor
			Timer.scheduledTimer(withTimeInterval: 0.02, repeats: false) { (timer) in
				button.layer?.backgroundColor = color
			}
		}
	}

	func buttonByTag(tag : Int)-> NSButton!{

		for button in buttons.allValues {
			if (button as! NSButton).tag == tag{
				return (button as! NSButton)
			}
		}

		let button = NSButton(title: "", target: nil, action: nil)
		button.tag = -1
		return button
	}

	@IBAction func copy(_ sender: Any?){
		let pasteBoard = NSPasteboard.general
		pasteBoard.clearContents()
		pasteBoard.setString(buffers.queue, forType: NSPasteboard.PasteboardType.string)
	}

	@IBAction func paste(_ sender: Any?){
		let string = NSPasteboard.general.string(forType: NSPasteboard.PasteboardType.string)
		let f = NumberFormatter.init()
		f.numberStyle = NumberFormatter.Style.decimal

		if let n : NSNumber = f.number(from: string!){
			buffers.opr = 207
			buffers.rightTerm = ""
			buffers.leftTerm = ""
			self.buffers.queue = n.stringValue
		}
	}
}

// MARK: Actions

extension CalcViewController {
	@IBAction func quit(_ sender: NSButton) {
		NSApplication.shared.terminate(sender)
	}

	@IBAction func loadAtStartup(_ sender: Any?) {
		let appBundleIdentifier : String = "com.nutznboltzllc.com.CalcMenuBarLauncher"

		if let menuItem : NSMenuItem = sender as? NSMenuItem {
			// Good
			if menuItem.state == .on {
				menuItem.state = .off
				SMLoginItemSetEnabled(appBundleIdentifier as CFString, false)
			}else{
				menuItem.state = .on
				SMLoginItemSetEnabled(appBundleIdentifier as CFString, true)
			}
		}
	}
}

extension CalcViewController {
	// MARK: Storyboard instantiation
	static func freshController() -> CalcViewController {
		//1.
		let storyboard = NSStoryboard(name: "Main", bundle: nil)

		//2.
		let identifier = NSStoryboard.SceneIdentifier("CalcViewController")

		//3.
		guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? CalcViewController else {
			fatalError("Why can't I find CalcViewController? - Check Main.storyboard")
		}
		return viewcontroller
	}
}

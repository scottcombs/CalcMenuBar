//
//  NSString+NSStringExtensions.swift
//  CalcMenuBar
//
//  Created by Scott on 11/7/18.
//  Copyright © 2018 Nutz & Boltz Productions. All rights reserved.
//

import Cocoa

extension NSString {
	enum Alignment : Int {
		case Left = 0,
		Right,
		Center
	}

	func drawFittedToRect(_ rect:NSRect, font:NSFont, color:NSColor, alignment:Alignment, vOffset:CGFloat, hOffset:CGFloat) -> Void {

		let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle.init()

		switch alignment {
		case NSString.Alignment.Left:
			paragraphStyle.alignment = NSTextAlignment.left

		case NSString.Alignment.Right:
			paragraphStyle.alignment = NSTextAlignment.right

		default: // CENTER
			paragraphStyle.alignment = NSTextAlignment.center
		}

		// Get the default width to calculate height
		let textStorage : NSTextStorage = NSTextStorage.init(string:self as String)
		let textContainer : NSTextContainer = NSTextContainer.init(containerSize: NSMakeSize(CGFloat(Float.greatestFiniteMagnitude), rect.size.height))
		let layoutMgr : NSLayoutManager = NSLayoutManager.init()
		layoutMgr.addTextContainer(textContainer)
		textStorage.addLayoutManager(layoutMgr)
		textStorage.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, textStorage.length))
		textContainer.lineFragmentPadding = 0.0
		layoutMgr.glyphRange(for: textContainer)
		let width : CGFloat = layoutMgr.usedRect(for: textContainer).size.width
		var fontSize : CGFloat = rect.size.height
		if width * 0.75 > rect.size.width {
			fontSize = ((rect.size.width / width) * rect.size.height) * 1.333
		}
		let attr : NSMutableDictionary = NSMutableDictionary.init()
		let newFont : NSFont = NSFont.init(name: font.fontName, size: fontSize)!
		attr.setValue(newFont, forKey: NSAttributedString.Key.font.rawValue)
		attr.setValue(color, forKey: NSAttributedString.Key.foregroundColor.rawValue)
		attr.setValue(paragraphStyle, forKey: NSAttributedString.Key.paragraphStyle.rawValue)
		var nRect : NSRect = rect
		// Adjust height in rect
		if fontSize < rect.size.height {
			let offset = (rect.size.height - fontSize)/2
			nRect = NSMakeRect(rect.origin.x, rect.origin.y + offset, rect.size.width, fontSize)
		}
		nRect.origin.y = nRect.origin.y - 10
		self.draw(in: nRect, withAttributes: (attr as! [NSAttributedString.Key : Any]))
	}

}

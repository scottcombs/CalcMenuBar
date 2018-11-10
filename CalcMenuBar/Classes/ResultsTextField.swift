//
//  ResultsTextField.swift
//  CalcMenuBar
//
//  Created by Scott on 11/7/18.
//  Copyright © 2018 Nutz & Boltz Productions. All rights reserved.
//

import Cocoa


class ResultsTextField: NSTextField {
	let dkGray : CGColor = NSColor.init(calibratedRed: 59/255, green: 51/255, blue: 49/255, alpha: 1).cgColor
	let white : CGColor = NSColor.white.cgColor

	override func awakeFromNib() {
		self.wantsLayer = true;
		self.layer?.backgroundColor = dkGray
	}

    override func draw(_ dirtyRect: NSRect) {
        //super.draw(dirtyRect)

        // Drawing code here.
		let path = NSBezierPath.init(rect: self.bounds)
		NSColor.init(cgColor: dkGray)?.set()
		path.fill()
		let rect = NSMakeRect(self.bounds.origin.x, self.bounds.origin.y + self.bounds.size.height * 0.25 - 1 , self.bounds.size.width, self.bounds.size.height * 0.75)
		(self.stringValue as NSString).drawFittedToRect(rect, font: NSFont.init(name: "Helvetica Neue Light", size: self.bounds.size.height)!, color: NSColor.white, alignment: NSString.Alignment.Right, vOffset: 0.0, hOffset: 0.0)
		
    }
    
}

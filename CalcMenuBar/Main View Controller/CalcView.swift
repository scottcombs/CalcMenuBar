//
//  CalcView.swift
//  CalcMenuBar
//
//  Created by Scott on 11/6/18.
//  Copyright © 2018 Nutz & Boltz Productions. All rights reserved.
//

import Cocoa

class CalcView: NSView {
	var contextMenu : NSMenu?
	var launchAtStartupMenuItem : NSMenuItem?

	override func awakeFromNib() {

		contextMenu = NSMenu(title: "contextMenu")
		contextMenu?.addItem(withTitle: "Copy", action: Selector(("myCopy:")), keyEquivalent: "c")
		contextMenu?.addItem(withTitle: "Paste", action: Selector(("myPaste:")), keyEquivalent: "v")
		contextMenu?.addItem(NSMenuItem.separator())
		self.launchAtStartupMenuItem = contextMenu?.addItem(withTitle: "Load At Startup", action: Selector(("loadAtStartup:")), keyEquivalent: "")
		contextMenu?.addItem(NSMenuItem.separator())
		contextMenu?.addItem(withTitle: "Quit", action: Selector(("quit:")), keyEquivalent: "q")
	}

	override var acceptsFirstResponder: Bool {
		return true
	}

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }

	override func rightMouseDown(with event: NSEvent) {
		self.onContextMenu(event)
	}

	override func mouseDown(with event: NSEvent) {
		if event.modifierFlags.contains(.control){
			self.onContextMenu(event)
		}
	}

	@IBAction func onContextMenu(_ sender: NSEvent){
		NSMenu.popUpContextMenu(contextMenu!, with: sender, for: self)
	}

	override func keyDown(with event: NSEvent) {
		let button : NSButton = NSButton(title: "", image: NSImage(), target: nil, action: nil)

		switch event.keyCode {

		/* NUMBERS */
		case 29: // 0
			button.tag = 0
			NSApp.sendAction(Selector(("numKeyClicked:")), to: nil, from: button)
		case 25: // 9
			button.tag = 9
			NSApp.sendAction(Selector(("numKeyClicked:")), to: nil, from: button)
		case 28: // 8 | Multiply
			if event.modifierFlags.contains(.shift){
				button.tag = 201
				NSApp.sendAction(Selector(("opKeyClicked:")), to: nil, from: button)
			}else{
				button.tag = 8
				NSApp.sendAction(Selector(("numKeyClicked:")), to: nil, from: button)
			}
		case 26: // 7
			button.tag = 7
			NSApp.sendAction(Selector(("numKeyClicked:")), to: nil, from: button)
		case 22: // 6
			button.tag = 6
			NSApp.sendAction(Selector(("numKeyClicked:")), to: nil, from: button)
		case 23: // 5
			if event.modifierFlags.contains(.shift){
				button.tag = 205
				NSApp.sendAction(Selector(("opKeyClicked:")), to: nil, from: button)
			}else{
				button.tag = 5
				NSApp.sendAction(Selector(("numKeyClicked:")), to: nil, from: button)
			}
		case 21: // 4
			button.tag = 4
			NSApp.sendAction(Selector(("numKeyClicked:")), to: nil, from: button)
		case 20: // 3
			button.tag = 3
			NSApp.sendAction(Selector(("numKeyClicked:")), to: nil, from: button)
		case 19: // 2
			button.tag = 2
			NSApp.sendAction(Selector(("numKeyClicked:")), to: nil, from: button)
		case 18: // 1
			button.tag = 1
			NSApp.sendAction(Selector(("numKeyClicked:")), to: nil, from: button)

		/* OPERATORS */
		case 27: // Minus or Plus Minus
			if event.modifierFlags.contains(.option) {
				// Plus Minus
				button.tag = 206
				NSApp.sendAction(Selector(("opKeyClicked:")), to: nil, from: button)
			}else{
				button.tag = 202
				NSApp.sendAction(Selector(("opKeyClicked:")), to: nil, from: button)
			}
		case 24: // Equal or Plus/Minus or Plus
			if event.modifierFlags.contains(.shift){
				// Plus
				button.tag = 203
				NSApp.sendAction(Selector(("opKeyClicked:")), to: nil, from: button)
			} else if event.modifierFlags.contains(.option) {
				// Plus Minus
				button.tag = 206
				NSApp.sendAction(Selector(("opKeyClicked:")), to: nil, from: button)
			}else{
				// Equal
				button.tag = 300
				NSApp.sendAction(Selector(("opKeyClicked:")), to: nil, from: button)
			}
		case 44: // Divide
			button.tag = 200
			NSApp.sendAction(Selector(("opKeyClicked:")), to: nil, from: button)
		case 47: // Period
			button.tag = 100
			NSApp.sendAction(Selector(("opKeyClicked:")), to: nil, from: button)
		case 51: // Delete
			if event.modifierFlags.contains(.option) {
				// All Clear
				button.tag = 207
				NSApp.sendAction(Selector(("opKeyClicked:")), to: nil, from: button)
			}else{
				button.tag = 400
				NSApp.sendAction(Selector(("opKeyClicked:")), to: nil, from: button)
			}
		case 36: // Enter
			button.tag = 300
			NSApp.sendAction(Selector(("opKeyClicked:")), to: nil, from: button)
		case 76: // Return
			button.tag = 300
			NSApp.sendAction(Selector(("opKeyClicked:")), to: nil, from: button)

		default: break
		}
	}
}

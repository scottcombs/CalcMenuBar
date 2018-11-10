//
//  AppDelegate.swift
//  CalcMenuBar
//
//  Created by Scott on 11/6/18.
//  Copyright © 2018 Nutz & Boltz Productions. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

	let popover = NSPopover()

	var eventMonitor: EventMonitor?

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		if let button = statusItem.button {
			button.image = NSImage(named:NSImage.Name("calc"))
			button.action = #selector(togglePopover(_:))
		}

		popover.contentViewController = CalcViewController.freshController()

		eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
			if let strongSelf = self, strongSelf.popover.isShown {
				strongSelf.closePopover(sender: event)
			}
		}

		self.loadDefaults(self)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
		self.saveDefaults(self)
	}

	@objc func togglePopover(_ sender: Any?) {
		if popover.isShown {
			closePopover(sender: sender)
		} else {
			showPopover(sender: sender)
		}
	}

	func showPopover(sender: Any?) {
		if let button = statusItem.button {
			popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
		}

		eventMonitor?.start()
	}

	func closePopover(sender: Any?) {
		popover.performClose(sender)

		eventMonitor?.stop()
	}

	@IBAction func loadDefaults(_ sender:Any?) {
		let prefs : UserDefaults = UserDefaults.standard
		let boolValue = prefs.bool(forKey: "launchAtStartup")
		let viewController : CalcViewController = popover.contentViewController as! CalcViewController
		let view : CalcView = viewController.view as! CalcView
		let menuItem : NSMenuItem = view.launchAtStartupMenuItem!
		if boolValue {
			menuItem.state = NSControl.StateValue.on
		}else{
			menuItem.state = NSControl.StateValue.off
		}

	}

	@IBAction func saveDefaults(_ sender:Any?) {
		let prefs : UserDefaults = UserDefaults.standard
		let viewController : CalcViewController = popover.contentViewController as! CalcViewController
		let view : CalcView = viewController.view as! CalcView

		switch view.launchAtStartupMenuItem!.state {
		case NSControl.StateValue.on:
				prefs.set(true, forKey: "launchAtStartup")
		default:
				prefs.set(false, forKey: "launchAtStartup")
		}
	}
}


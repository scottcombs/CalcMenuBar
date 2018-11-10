//
//  NSColor+NSColorExtensions.swift
//  CalcMenuBar
//
//  Created by Scott on 11/7/18.
//  Copyright © 2018 Nutz & Boltz Productions. All rights reserved.
//

import AppKit

extension NSColor {
	class func invertedColor(color : CGColor!) -> CGColor{
		if color.components?.count == 4{
			let red : CGFloat = 1.0 - color.components![0]
			let grn : CGFloat = 1.0 - color.components![1]
			let blu : CGFloat = 1.0 - color.components![2]
			let alp : CGFloat = color.components![3]
			let aColor : CGColor = CGColor(red: red, green: grn, blue: blu, alpha: alp)
			return aColor
		}else{
			return color
		}
	}
}

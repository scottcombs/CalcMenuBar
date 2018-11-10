//
//  String+StringExtensions.swift
//  CalcMenuBar
//
//  Created by Scott on 11/9/18.
//  Copyright © 2018 Nutz & Boltz Productions. All rights reserved.
//

import Foundation

extension String {

	func floatNumber() -> Float {
		if let f = Float(self){
			return f
		}else{
			return 0.0
		}
	}
	
	func intNumber() -> Int {
		if let i = Int(self){
			return i
		}else{
			return 0
		}
	}
}

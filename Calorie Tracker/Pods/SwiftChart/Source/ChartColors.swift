//
//  ChartColors.swift
//
//  Created by Giampaolo Bellavite on 07/11/14.
//  Copyright (c) 2014 Giampaolo Bellavite. All rights reserved.
//

import UIKit

/**
Shorthands for various colors to use in the charts.
*/
public struct ChartColors {

    fileprivate static func colorFromHex(_ hex: Int) -> UIColor {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

    public static func blueColor() -> UIColor {
        return colorFromHex(0x4A90E2)
    }
    public static func orangeColor() -> UIColor {
        return colorFromHex(0xF5A623)
    }
    public static func greenColor() -> UIColor {
        return colorFromHex(0x7ED321)
    }
    public static func darkGreenColor() -> UIColor {
        return colorFromHex(0x417505)
    }
    public static func redColor() -> UIColor {
        return colorFromHex(0xFF3200)
    }
    public static func darkRedColor() -> UIColor {
        return colorFromHex(0xD0021B)
    }
    public static func purpleColor() -> UIColor {
        return colorFromHex(0x9013FE)
    }
    public static func maroonColor() -> UIColor {
        return colorFromHex(0x8B572A)
    }
    public static func pinkColor() -> UIColor {
        return colorFromHex(0xBD10E0)
    }
    public static func greyColor() -> UIColor {
        return colorFromHex(0x7f7f7f)
    }
    public static func cyanColor() -> UIColor {
        return colorFromHex(0x50E3C2)
    }
    public static func goldColor() -> UIColor {
        return colorFromHex(0xbcbd22)
    }
    public static func yellowColor() -> UIColor {
        return colorFromHex(0xF8E71C)
    }
}

//
//  CTColors.swift
//  CTHelpSPMMaster
//
//  Created by Stewart Lynch on 2019-08-21.
//  Copyright © 2019 CreaTECH Solutions. All rights reserved.
//

import UIKit


public class CTColors {
    public var bgViewColor:UIColor?
    public var helpTextColor:UIColor?
    public var titleColor:UIColor?
    public var actionButtonBGColor:UIColor?
    public var actionButtonTextColor:UIColor?
    public var closeButtonBGColor:UIColor?
    public var pageControlColor:UIColor?
    
    public init(bgViewColor: UIColor? = nil,
                helpTextColor: UIColor? = nil,
                titleColor: UIColor? = nil,
                actionButtonBGColor: UIColor? = nil,
                actionButtonTextColor: UIColor? = nil,
                closeButtonBGColor: UIColor? = nil,
                pageControlColor: UIColor? = nil) {
        self.bgViewColor = bgViewColor
        self.helpTextColor = helpTextColor
        self.titleColor = titleColor
        self.actionButtonBGColor = actionButtonBGColor
        self.actionButtonTextColor = actionButtonTextColor
        self.closeButtonBGColor = closeButtonBGColor
        self.pageControlColor = pageControlColor
    }
    

}

//
//  CTHelp.swift
//  CreaTECH Help
//
//  Created by Stewart Lynch on 06/30/19.
//  Copyright © 2019 CreaTECH Solutiions. All rights reserved.
//

import SwiftUI

public class CTHelp {
    
    public var helpItems:[CTHelpItem] = []
    
    // Custom Strings and colors
    
    public var ctString:CTString?
    public var ctColors:CTColors?
    
    public init(ctString:CTString? = nil, ctColors:CTColors? = nil){
        self.ctString = ctString
        self.ctColors = ctColors
    }
    /// Create a new help item and add it to the helpItems Array.
    ///
    /// - Parameter helpItem: an item of help.
    public func new(_ ctHelpItem:CTHelpItem) {
        helpItems.append(ctHelpItem)
    }
    
    /// Add defaults to the end of the helpItems array.
    /// - Parameter companyName: Name of your company
    /// - Parameter emailAddress: contact email address
    /// - Parameter data: application data
    /// - Parameter webSite: url for your website
    /// - Parameter companyImageName: the name of your company image
    public func appendDefaults(companyName:String, emailAddress:String?, data:Data?, webSite:String?, companyImageName:String?) {
        let contactBody1 = ctString?.contactHelpText ?? "\(companyName) would very much like to assist you if you are having issues with \(Bundle.main.displayName). Please tap button below to initiate an email to the developer."
        let contactBody2 = ctString?.includeDataText ?? "  If you agree, your data will be compiled and sent to the developer for analysis."
        
        let developerWebSite = CTHelpItem(title:"\(companyName)",
            helpText: ctString?.webHelpText ?? "\(Bundle.main.displayName) is created by \(companyName).  Please visit our website for more information about our company.",
            imageName:companyImageName ?? "",
            btn:.Web,
            webSite: webSite)
        let appContact = CTHelpItem(title: ctString?.contactTitle ?? "Contact Developer",
                                    helpText: contactBody1 + (data != nil ? contactBody2 : ""),
                                    imageName: "",
                                    btn:.Email,
                                    contactEmail:emailAddress,
                                    data:data)
        if let _ = webSite {
            helpItems.append(developerWebSite)
        }
        if let _ = emailAddress {
            helpItems.append(appContact)
        }
        
    }
    
    public func showCTHelpView(ctHelp:CTHelp,
                               showCTHelp:Binding<Bool>) -> some View {
        ZStack {
            Color(.label).opacity(0.2).edgesIgnoringSafeArea(.all)
            SwiftUIPagerView(
                pages: (0..<helpItems.count).map {
                    // Pass in CTString and CTColors too here
                    index in CTHelpCardView(index: index,
                                            total: ctHelp.helpItems.count,
                                            helpItem: helpItems[index],
                                            bgViewColor: ctColors?.bgViewColor,
                                            titleColor: ctColors?.titleColor,
                                            helpTextColor: ctColors?.helpTextColor,
                                            actionButtonBGColor: ctColors?.actionButtonBGColor,
                                            actionButtonTextColor: ctColors?.actionButtonTextColor,
                                            closeButtonBGColor: ctColors?.closeButtonBGColor,
                                            pageControlColor:ctColors?.pageControlColor,
                                            ctString: ctString,
                                            showCTHelp: showCTHelp)
            })
        }
    }
}

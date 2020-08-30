//
//  CTHelp.swift
//  CreaTECH Help
//
//  Created by Stewart Lynch on 06/30/19.
//  Copyright © 2019 CreaTECH Solutions. All rights reserved.
//

import SwiftUI

public class CTHelp {
    /// an array of CTHelpItems
    public var helpItems:[CTHelpItem] = []
    
    /// Width of the card - default is 300
    public var width: CGFloat
    /// Height of the card - default is 285
    public var height: CGFloat

    /// Optional set of custom strings
    public var ctString:CTString?

    /// Optional set of custom colors
    public var ctColors:CTColors?
    
    public init(width: CGFloat = 300, height: CGFloat = 285, ctString:CTString? = nil, ctColors:CTColors? = nil) {
        self.ctString = ctString
        self.ctColors = ctColors
        self.width = width
        self.height = height
    }


    /// Clears the helpItems Array
    public func clearItems() {
        helpItems.removeAll()
    }


    /// Append new item to the CTHelpItem Array
    /// - Parameter ctHelpItem: a CTHelpItem
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


    /// Presents the set of help screens
    /// - Parameters:
    ///   - isPresented: a binding to the @State Boolean variable that is used to present the screens
    ///   - ctHelp: the ctHelp class containing the array of CTHelpItem and other optional properties
    /// - Returns: The screens in a horizontally scrolling view over the current view
    public func  showCTHelpScreens(isPresented:Binding<Bool>, ctHelp:CTHelp) -> some View {
        ZStack {
            Color(.label).opacity(0.2)
                .ignoresSafeArea()
                CTHelpScreens(isPresenting: isPresented, ctHelp: ctHelp)
                    .navigationBarHidden(true)
        }
        .zIndex(1)
    }
}

extension CTHelp {
    static func previewSet() -> CTHelp {
        let ctHelp = CTHelp()
        // Card 1 is a card with no text and a single image
        ctHelp.new(CTHelpItem(title: "My Books", helpText: "", imageName: "My Books Logo"))
//        // Card 2 is a card with no image and text only
        ctHelp.new(CTHelpItem(title:"List of books",
                          helpText: "This screen shows a list of all of the books that you have read.\nAs you read more books you read more books you can add to this list.\nYou can also remove books from the list as well.  See the other help screens here for more information.",
                          imageName:""))
//        // card 3 has an image and text
        ctHelp.new(CTHelpItem(title:"Adding a Book",
                          helpText: "To add a book to your collection, tap on the '+' button on the navigation bar.\nEnter the book title and author and tap the 'Add' button",
                          imageName:"AddBook"))
//        // card 4 has an image and text
        ctHelp.new(CTHelpItem(title:"Removing a Book",
                          helpText: "To remove a book from your list, swipe from the right to the left and choose 'Remove Book'.",
                          imageName:"RemoveBook"))
//        // card 5 has an image and text
        ctHelp.new(CTHelpItem(title: "Book Detail",
                          helpText: "Tap on the 'More' button to view more detail about the book",
                          imageName: "More"))
        return ctHelp
    }
}

//
//  CTString.swift
//  CTHelp
//
//  Created by Stewart Lynch on 2019-05-13.
//

import Foundation

public class CTString {

    public init(contactTitle: String? = nil,
                contactButtonTitle: String? = nil,
                webButtonTitle: String? = nil,
                dataAlertTitle: String? = nil,
                dataAlertMessage: String? = nil,
                dataAlertActionNo: String? = nil,
                dataAlertActionYes: String? = nil,
                emailSubject: String? = nil,
                emailBody: String? = nil,
                emailAttachNote: String? = nil,
                contactHelpText: String? = nil,
                includeDataText: String? = nil,
                webHelpText: String? = nil) {
        self.contactTitle = contactTitle
        self.contactButtonTitle = contactButtonTitle
        self.webButtonTitle = webButtonTitle
        self.dataAlertTitle = dataAlertTitle
        self.dataAlertMessage = dataAlertMessage
        self.dataAlertActionNo = dataAlertActionNo
        self.dataAlertActionYes = dataAlertActionYes
        self.emailSubject = emailSubject
        self.emailBody = emailBody
        self.emailAttachNote = emailAttachNote
        self.contactHelpText = contactHelpText
        self.includeDataText = includeDataText
        self.webHelpText = webHelpText
    }
    

    public var contactTitle:String?
    public var contactButtonTitle:String?
    public var webButtonTitle:String?
    public var dataAlertTitle:String?
    public var dataAlertMessage:String?
    public var dataAlertActionNo:String?
    public var dataAlertActionYes:String?
    public var emailSubject:String?
    public var emailBody:String?
    public var emailAttachNote:String?
    public var contactHelpText:String?
    public var includeDataText:String?
    public var webHelpText:String?
    
    
}


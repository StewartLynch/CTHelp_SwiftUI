//
//  CTHelpMailView.swift
//  PagerVC
//
//  Created by Stewart Lynch on 2019-12-21.
//  Copyright © 2019 CreaTECH Solutions. All rights reserved.
//

import SwiftUI
import UIKit
import MessageUI

struct MailView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    let ctString:CTString?
    let address:String?
    let data: Data?
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let clientInfo = CTSourceInfo()
        var body:String = "<b>\(clientInfo.appName)</b><p>"
        body += "iOS: \(clientInfo.iOSVersion)</br>"
        body += "Device Version: \(clientInfo.deviceVersion)</br>"
        body += "App Version: \(clientInfo.appVersion)<p>"
        let vc = MFMailComposeViewController()
        if let data = data {
            body += ctString?.emailAttachNote ?? "<b>Note:</b>\(clientInfo.appName) data is attached."
            body += "<p>"
            vc.addAttachmentData(data, mimeType: "text/plain", fileName: "\(clientInfo.appName).json")
        }
        body += ctString?.emailBody ?? "Please describe the issue you are having in as much detail as possible:"
        vc.setMessageBody(body, isHTML: true)
        vc.setSubject(ctString?.emailSubject ?? "\(clientInfo.appName) Issue")
        if let address = address {
           vc.setToRecipients([address])
        }
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}

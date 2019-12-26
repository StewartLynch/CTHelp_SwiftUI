//
//  CTHelpPageView.swift
//  PagerVC
//
//  Created by Stewart Lynch on 2019-12-20.
//  Copyright © 2019 CreaTECH Solutions. All rights reserved.
//

import SwiftUI
import MessageUI

struct CTHelpCardView: View, Identifiable {
    let id = UUID()
    let index:Int
    let total:Int
    let helpItem:CTHelpItem
    let bgViewColor: UIColor?
    let titleColor: UIColor?
    let helpTextColor: UIColor?
    let actionButtonBGColor: UIColor?
    let actionButtonTextColor: UIColor?
    let closeButtonBGColor: UIColor?
    let pageControlColor: UIColor?
    let ctString: CTString?
    @State private var includeData = false
    
    @Binding var showCTHelp:Bool
    @State private var showAlert = false
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 20)
            ZStack {
                // This is the background card
                RoundedRectangle(cornerRadius: 10)
                    .fill(bgViewColor == nil ? Color(.systemBackground) : Color(bgViewColor!))
                    .shadow(radius: 10)
                    .frame(width:315, height:285)
                VStack {
                    HStack() {
                        // Title and Close Button
                        Text(helpItem.title)
                            .font(.title)
                            .foregroundColor(titleColor == nil ? Color(.label) : Color(titleColor!))
                            .allowsTightening(true)
                            .truncationMode(.middle)
                            .lineLimit(1)
                            .padding(.leading)
                        Spacer()
                        Button(action: {
                            self.showCTHelp = false
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(closeButtonBGColor == nil ? Color(.gray) : Color(closeButtonBGColor!))
                                .font(.headline)
                                .frame(width: 40, height: 40)
                        }
                    }
                    // Content
                    VStack {
                        if helpItem.imageName != "" {
                            Image(helpItem.imageName)
                        }
                        
                        ScrollView {
                            VStack {
                                Text(helpItem.helpText)
                                    .font(.callout)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(helpTextColor == nil ? Color(.label) : Color(helpTextColor!))
                            }.padding(.horizontal)
                        }
                        if helpItem.btn == .Web {
                            Button(action: {
                                if let webSite = self.helpItem.webSite {
                                    guard let url = URL(string: webSite) else {return}
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }) {
                                Text(ctString?.webButtonTitle == nil ? "Visit Web Site" : "\(ctString!.webButtonTitle!)")
                                    .padding(.horizontal)
                                    .padding(.vertical,5)
                                    .foregroundColor(actionButtonTextColor == nil ?.white : Color(actionButtonTextColor!))
                                    .background(actionButtonBGColor == nil ? Color.blue : Color(actionButtonBGColor!))
                                    .cornerRadius(5)
                            }
                        }
                        
                        if helpItem.btn == CTButtonType.Email {
                            Button(action: {
                                if let _ = self.helpItem.data {
                                    // show an alert asking to include data
                                    self.showAlert = true
                                } else {
                                    // if not, go ahead and send mail without data
                                    self.isShowingMailView.toggle()
                                }
                            }) {
                                Text(ctString?.contactButtonTitle == nil ? "Contact Developer" : "\(ctString!.contactButtonTitle!)")
                                    .padding(.horizontal)
                                    .padding(.vertical,5)
                                    .foregroundColor(actionButtonTextColor == nil ?.white : Color(actionButtonTextColor!))
                                    .background(actionButtonBGColor == nil ? Color.blue : Color(actionButtonBGColor!))
                                    .cornerRadius(5)
                            }
                            .alert(isPresented:$showAlert) {
                                Alert(title: Text(self.ctString?.dataAlertTitle == nil ? "Attach application" : "\(self.ctString!.dataAlertTitle!)"),
                                      message: Text(self.ctString?.dataAlertMessage == nil ? "Would you like to attach your application data to this message to assist the developer in troubleshooting?" : "\(self.ctString!.dataAlertMessage!)"),
                                      primaryButton: .default(Text("Yes")) {
                                        self.includeData = true
                                        self.isShowingMailView.toggle()
                                    },
                                      secondaryButton:  .cancel(Text("No")) {
                                        self.includeData = false
                                        self.isShowingMailView.toggle()
                                    })
                            }
                            .disabled(!MFMailComposeViewController.canSendMail())
                        }
                        
                    }
                    Spacer()
                }
                
            }
            HStack {
                ForEach(0..<total) { index in
                    if index == self.index {
                        Image(systemName: "circle.fill").foregroundColor(self.pageControlColor == nil ? Color(.secondaryLabel) : Color(self.pageControlColor!))
                            .font(.caption)
                        
                    } else {
                        Image(systemName: "circle")
                            .font(.caption).foregroundColor(self.pageControlColor == nil ? Color(.secondaryLabel) : Color(self.pageControlColor!))
                    }
                }
                
            }.padding()
                .sheet(isPresented: $isShowingMailView) {
                    MailView(result: self.$result, ctString: self.ctString, address: self.helpItem.contactEmail, data: self.includeData ? self.helpItem.data: nil)
            }
        }
        .frame(width: 315, height: 290, alignment: .leading)
    }
}


extension Int {
    func ctHelpkeepIndexInRange(min: Int, max: Int) -> Int {
        switch self {
        case ..<min: return min
        case max...: return max
        default: return self
        }
    }
}

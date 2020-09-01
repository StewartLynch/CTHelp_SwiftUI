//
//  CTHelpCardView.swift
//  CTHelp_SwiftUI-2
//
//  Created by Stewart Lynch on 2020-08-26.
//

import SwiftUI
import MessageUI

struct CTHelpCardView : View, Identifiable {
    let id = UUID()
    let helpItem:CTHelpItem
    let bgViewColor: UIColor?
    let titleColor: UIColor?
    let helpTextColor: UIColor?
    let actionButtonBGColor: UIColor?
    let actionButtonTextColor: UIColor?
    let closeButtonBGColor: UIColor?
    let ctString: CTString?
    @State private var includeData = false
    
    @Binding var showCTHelp:Bool
    @State private var showAlert = false
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    let width: CGFloat
    let height: CGFloat
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 20)
            ZStack {
                // This is the background card
                RoundedRectangle(cornerRadius: 10)
                    .fill(bgViewColor == nil ? Color(.systemBackground) : Color(bgViewColor!))
                    .shadow(radius: 10)
                    .frame(width:width, height:height)
                VStack {
                    HStack() {
                        // Title and Close Button
                        Text(helpItem.title)
                            .font(.title)
                            .foregroundColor(titleColor == nil ? Color(.label) : Color(titleColor!))
                            .allowsTightening(true)
                            .minimumScaleFactor(0.5)
                            .truncationMode(.middle)
                            .lineLimit(1)
                            .padding(.leading)
                        Spacer()
                        Button(action: {
                            withAnimation {
                                self.showCTHelp = false
                            }
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .font(.title)
                                .foregroundColor(closeButtonBGColor == nil ? Color(.gray) : Color(closeButtonBGColor!))
                                .font(.headline)
                                .frame(width: 44, height: 44)
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
                                Text(contactButtonTitle())
                                    .padding(.horizontal)
                                    .padding(.vertical,5)
                                    .foregroundColor(actionButtonTextColor == nil ?.white : Color(actionButtonTextColor!))
                                    .background(actionButtonBGColor == nil ? Color.blue : Color(actionButtonBGColor!))
                                    .cornerRadius(5)
                            }
                            .alert(isPresented:$showAlert) {
                                Alert(title: Text(self.ctString?.dataAlertTitle == nil ? "Attach application data" : "\(self.ctString!.dataAlertTitle!)"),
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
                            .opacity(!MFMailComposeViewController.canSendMail() ? 0.5 : 1.0)
                        }
                        
                    }
                    Spacer()
                }
                
            }
            .sheet(isPresented: $isShowingMailView) {
                MailView(result: self.$result, ctString: self.ctString, address: self.helpItem.contactEmail, data: self.includeData ? self.helpItem.data: nil)
            }
        }
        .frame(width: width, height: height, alignment: .leading)
    }
    
    func contactButtonTitle() -> String {
        if !MFMailComposeViewController.canSendMail() {
            return "Can't send mail"
        } else {
            return ctString?.contactButtonTitle == nil ? "Contact Developer" : "\(ctString!.contactButtonTitle!)"
        }
        
    }
}


struct CTHelpCardView_Previews: PreviewProvider {
    static let helpItem = CTHelp.previewSet().helpItems[0]
    static var previews: some View {
        Group {
            CTHelpCardView(helpItem: helpItem,
                           bgViewColor: nil,
                           titleColor: nil,
                           helpTextColor: nil,
                           actionButtonBGColor: nil,
                           actionButtonTextColor: nil,
                           closeButtonBGColor: nil,
                           ctString: nil,
                           showCTHelp: .constant(true),
                           width: 300,
                           height: 285)
            
            CTHelpCardView(helpItem: helpItem, bgViewColor: nil, titleColor: nil, helpTextColor: nil, actionButtonBGColor: nil, actionButtonTextColor: nil, closeButtonBGColor: nil, ctString: nil, showCTHelp: .constant(true), width: 300, height: 285)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}

//
//  CTHelpScreens.swift
//  CTHelp_SwiftUI-2
//
//  Created by Stewart Lynch on 2020-08-26.
//

import SwiftUI

struct CTHelpScreens: View {
    @Binding var isPresenting: Bool
    var ctHelp: CTHelp
    var body: some View {
        VStack {
            TabView {
                ForEach(ctHelp.helpItems) { helpItem in
                    CTHelpCardView(helpItem: helpItem,
                                   bgViewColor: ctHelp.ctColors?.bgViewColor,
                                   titleColor: ctHelp.ctColors?.titleColor,
                                   helpTextColor: ctHelp.ctColors?.helpTextColor,
                                   actionButtonBGColor: ctHelp.ctColors?.actionButtonBGColor,
                                   actionButtonTextColor: ctHelp.ctColors?.actionButtonTextColor,
                                   closeButtonBGColor: ctHelp.ctColors?.closeButtonBGColor,
                                   ctString: ctHelp.ctString,
                                   showCTHelp: $isPresenting,
                                   width: ctHelp.width,
                                   height: ctHelp.height)
                }

            }
            .frame(maxWidth: .infinity)
            .frame(height: ctHelp.height + 120)
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            Spacer()
        }
    }
}

struct CTHelpScreens_Previews: PreviewProvider {
    static var previews: some View {
            CTHelpScreens(isPresenting: .constant(true), ctHelp: CTHelp.previewSet())
    }
}




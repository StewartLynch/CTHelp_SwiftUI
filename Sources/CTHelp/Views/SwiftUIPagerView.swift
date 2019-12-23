//
//  SwiftUIPagerView.swift
//  PagerVC
//
//  Created by Stewart Lynch on 2019-12-20.
//  Copyright © 2019 CreaTECH Solutions. All rights reserved.
//

import SwiftUI

struct SwiftUIPagerView<Content: View & Identifiable>: View {
    @State private var index: Int = 0
    @State private var offset: CGFloat = 0
    var pages: [Content]
    var body: some View {
        GeometryReader { geometry in
            VStack{
                HStack(alignment: .center, spacing: 0) {
                    ForEach(self.pages) { page in
                        page
                            .frame(width: geometry.size.width, height: nil)
                    }
                }.offset(x: self.offset)
            .frame(width: geometry.size.width, height: nil, alignment: .leading)
            .gesture(DragGesture()
            .onChanged({ value in
                
                self.offset = value.translation.width - geometry.size.width * CGFloat(self.index)
            })
                .onEnded({ value in
                    if abs(value.predictedEndTranslation.width) >= geometry.size.width / 2 {
                        var nextIndex: Int = (value.predictedEndTranslation.width < 0) ? 1 : -1
                        nextIndex += self.index
                        self.index = nextIndex.ctHelpkeepIndexInRange(min: 0, max: self.pages.endIndex - 1)
                    }
                    withAnimation { self.offset = -geometry.size.width * CGFloat(self.index) }
                })
            )
                Spacer()
        }
        
    }
    }
}

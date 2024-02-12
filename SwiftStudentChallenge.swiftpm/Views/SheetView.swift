//
//  SheetView.swift
//
//
//  Created by Victor Hugo Pacheco Araujo on 30/01/24.
//

import SwiftUI

struct SheetView: View {
    
    @Binding var openSheet: Bool
    
    var body: some View {
        
        VStack {
            
            Text(Texts.tennis).font(.title).padding()
            
            VStack(alignment: .leading) {
                Text(Texts.textSheet1).font(.title3)
                Text(Texts.textSheet2).font(.title3)
            }.padding()
            
            Spacer()
            
            Image(Texts.ballImageName)
            
            Spacer()
            
            VStack{
                HStack{
                    Text(Texts.play).foregroundStyle(.white)
                        .font(.title3)
                }.padding()
            }.background(RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.green)
            )
            .padding()
            .onTapGesture {
                openSheet.toggle()
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.myBlue)
        
    }
}

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
        
        VStack{
            VStack {
                
                Text(Texts.tennis).font(.title).padding()
                
                Text(Texts.textSheet1).font(.title3)
                Text(Texts.textSheet2).font(.title3)
                
                Spacer()
                
                Image(Texts.ballImageName)
                
                Spacer()
  
                VStack{
                    HStack{
                        Text(Texts.play).foregroundStyle(.white)
                    }.padding()
                }.background(RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.green)
                )
                .padding()
                .onTapGesture {
                    openSheet.toggle()
                }
                
            }.padding()
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.myBlue)
        
    }
}

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
                
                Text("Tennis").font(.title).padding()
                
                Text(" - This scene will use the AR to explain just a little bit about how the tennis score works.").font(.title3)
                Text(" - The next View is an ARView, so please look for a horizontal surface, like a floor to see the magic happens.").font(.title3)
                
                Spacer()
                
                Image("bolinhaImagem")
                
                Spacer()
  
                VStack{
                    HStack{
                        Text("Play").foregroundStyle(.white)
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
            .background(Color.azulClaro)
        
    }
}

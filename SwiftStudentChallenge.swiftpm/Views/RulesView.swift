//
//  RulesView.swift
//  
//
//  Created by Victor Hugo Pacheco Araujo on 30/01/24.
//

import SwiftUI

struct RulesView: View {
    
    @Binding var openSheet: Bool
    
    var body: some View {
        
        VStack{
            VStack {
                
                Text("Tennis").font(.title).padding()
              
                Text(" - This scene will use the AR to explain just a little bit about how the tennis score works.")
                Text(" - The next View is an ARView, so please look for a horizontal surface, like a floor to see the magic happens")
                
                Spacer()
                
                VStack{
                    HStack{
                        Text("Play").foregroundStyle(.white)
                    }.padding()
                }.background(RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.green)
                )
                .padding()
                
                
            }.padding()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.gray))
            
        
    }
}

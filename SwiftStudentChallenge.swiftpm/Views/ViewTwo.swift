//
//  CongratsView.swift
//
//
//  Created by Victor Hugo Pacheco Araujo on 02/12/23.
//

import SwiftUI

struct ViewTwo: View {
    
    var body: some View {
        
        VStack {
            
            ZStack {
                Image("fundoTexto")
                    .resizable()
                    .scaledToFit()
                HStack {
                    Text(Texts.text2)
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding()
                }
                .padding()
            }.padding(.horizontal)
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink(destination: {
                        MyARView()
                    }, label: {
                        
                        VStack{
                            HStack{
                                Text("Next").foregroundStyle(.white)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.white)
                                
                            }.padding()
                        }.background(RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.green)
                        )
                        .padding()
                        
                    })
                    
                }
                .padding()
            }
            
        }.background(
            Image("background")
                .resizable()
                .scaledToFill()
                .clipped()
                .ignoresSafeArea(.all)
        )
  
    }
}

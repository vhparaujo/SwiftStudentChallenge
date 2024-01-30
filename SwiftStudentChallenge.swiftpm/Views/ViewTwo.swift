//
//  CongratsView.swift
//
//
//  Created by Victor Hugo Pacheco Araujo on 02/12/23.
//

import SwiftUI

struct ViewTwo: View {
    
    @State var openSheet: Bool = false
    
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
                    .onTapGesture {
                        openSheet.toggle()
                    }
            
//                    NavigationLink(destination: {
//                        ARViewContainer().ignoresSafeArea(.all)
//                    }, label: {
//                        
//                        VStack{
//                            HStack{
//                                Text("Play").foregroundStyle(.white)
//                                
//                                Image(systemName: "chevron.right")
//                                    .foregroundStyle(.white)
//                                
//                            }.padding()
//                        }.background(RoundedRectangle(cornerRadius: 10)
//                            .foregroundStyle(.green)
//                        )
//                        .padding()
//                        
//                    })
                    
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
        
        .sheet(isPresented: $openSheet) {
            RulesView(openSheet: $openSheet)
        }
        
    }
}

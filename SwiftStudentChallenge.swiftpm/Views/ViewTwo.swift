//
//  CongratsView.swift
//
//
//  Created by Victor Hugo Pacheco Araujo on 02/12/23.
//

import SwiftUI

struct ViewTwo: View {
    
    @State var orientation = UIDeviceOrientation.unknown
    
    var body: some View {
        
        VStack {
            
            ZStack {
                Image(Texts.backgroundText)
                    .resizable()
                    .scaledToFit()
                HStack {
                    
                    if orientation.isPortrait {
                        Text(Texts.text2)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                    } else {
                        Text(Texts.text2)
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding()
                    }
                }
                .padding()
            }.padding(.horizontal)
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink(destination: {
                        TennisScoreView().navigationBarBackButtonHidden(true)
                    }, label: {
                        
                        VStack{
                            HStack{
                                Text(Texts.nextButton).foregroundStyle(.white)
                                    .font(.title3)
                                
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
            Image(Texts.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
        )
        
        .onRotate { newOrientation in
            orientation = newOrientation
        }
        
    }
}

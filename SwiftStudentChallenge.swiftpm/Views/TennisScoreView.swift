//
//  TennisScoreView.swift
//
//
//  Created by Victor Hugo Pacheco Araujo on 08/02/24.
//

import SwiftUI

// TODO: Trocar a imagem dos textos pela versão programática.

struct TennisScoreView: View {
    var body: some View {
        
        VStack{
 
            HStack{
                Image(Texts.smallRacquet1)
                Spacer()
                Text("How tennis works?")
                    .font(.largeTitle).fontWeight(.semibold)
                Spacer()
                Image(Texts.smallBall)
                    .padding()
            }.padding()
            
            Spacer()
            
            VStack {
                Image("TextsScore")
                    .cornerRadius(10)
            }
            
            NavigationLink(destination: {
                MyARView()
            }, label: {
                
                VStack{
                    HStack{
                        Text(Texts.nextButton).foregroundStyle(.white)
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.white)
                        
                    }.padding()
                }.background(RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.green)
                )
                .padding()
                
            })
            
            Spacer()
           
            HStack{
                Image(Texts.smallBall)
                    .padding()
                Spacer()
                Image(Texts.smallRacquet2)
            }.padding()
           
        }.background(Color.myBlue)
        
    }
}

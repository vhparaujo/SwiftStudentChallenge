//
//  TennisScoreView.swift
//
//
//  Created by Victor Hugo Pacheco Araujo on 08/02/24.
//

import SwiftUI

struct TennisScoreView: View {
    var body: some View {
        ZStack{
            VStack{
                VStack(alignment: .leading){
                    Text(Texts.firstTopic)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                        .font(.title3).fontWeight(.semibold)
                    
                    Text(Texts.secondTopic)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                        .font(.title3).fontWeight(.semibold)
                    
                    Text(Texts.thirdTopic)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                        .font(.title3).fontWeight(.semibold)
                    
                    Text(Texts.fourthTopic)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                        .font(.title3).fontWeight(.semibold)
                    
                    Text(Texts.fifthTopic)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                        .font(.title3).fontWeight(.semibold)
                }
                
                .background(Color.myDarkBlue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
                
                NavigationLink(destination: {
                    MyARView()
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
                
                
            }.padding(.top, 40)
            
            VStack{
                HStack{
                    Image(Texts.smallRacquet1)
                        .padding(.horizontal)
                    Spacer()
                    Text(Texts.howTennisWorks)
                        .font(.largeTitle).fontWeight(.semibold)
                    Spacer()
                    Image(Texts.smallBall)
                        .padding(.horizontal)
                    
                }.padding(.horizontal)
                
                Spacer()
                
                HStack{
                    Image(Texts.smallBall)
                        .padding(.horizontal)
                    Spacer()
                    Image(Texts.smallRacquet2).padding(.horizontal)
                }.padding()
            }
            
        }.background(Color.myBlue)
        
    }
}

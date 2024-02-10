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
                    Text("- A tennis match is divided into sets, games, and points. A set consists of a bunch of games, and a game consists of a bunch of points.")
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                        .font(.title3).fontWeight(.semibold)
                    
                    Text("- You score a point when the ball bounces in your opponent's court and they fail to hit it back. If you mess up your serve more than once or throw the ball out of the service area, the point goes to your opponent.")
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                        .font(.title3).fontWeight(.semibold)
                    
                    Text("- Points are counted like this: first point is 15, second is 30, third is 40, and the fourth one wins you the game.")
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                        .font(.title3).fontWeight(.semibold)
                    
                    Text("- To win a set, you need to be the first to get 6 games, with at least a two-game lead over your opponent.")
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                        .font(.title3).fontWeight(.semibold)
                    
                    Text("- To win the match, you have to win the best of three or best of five sets.")
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
                    Spacer()
                    Text("How tennis works?")
                        .font(.largeTitle).fontWeight(.semibold)
                    Spacer()
                    Image(Texts.smallBall)
                    
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

#Preview {
    TennisScoreView()
}

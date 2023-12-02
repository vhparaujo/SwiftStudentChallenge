//
//  SwiftUIView.swift
//  
//
//  Created by Victor Hugo Pacheco Araujo on 02/12/23.
//

import SwiftUI

struct ViewTwo: View {
  
  @State private var isAnimating = false
  
    var body: some View {
      NavigationView {
        
        VStack {
          HStack {
            VStack {
              Text(Texts.text2)
                .font(.title)
              Spacer()
            }.padding()
          }.padding(30)
          
          VStack{
            Spacer()
            HStack{
              Spacer()
            
              NavigationLink(destination: {
                
              }, label: {
                Text("Next")
                  .foregroundStyle(.black)
                Image("tenis")
                  .resizable()
                  .scaledToFit()
                  .frame(maxWidth: 100, maxHeight: 100)
                  .padding()
                  .opacity(isAnimating ? 0 : 0.5)
                  .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: UUID())
              })
            }
            .padding()
          }
          
          .onAppear {
            self.isAnimating = true
          }
          
        }.background(
          Image("background")
            .resizable()
            .scaledToFill()
            .clipped()
            .ignoresSafeArea(.all)
        )
        
      }
      .navigationViewStyle(.stack)
    }
}

#Preview {
    ViewTwo()
}

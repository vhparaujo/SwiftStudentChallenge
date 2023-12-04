import SwiftUI

struct ViewOne: View {
  
  @State private var isAnimating = false
  
  var body: some View {
    
    NavigationView {
      
      VStack {
        HStack {
          VStack {
            Text(Texts.text1)
              .font(.title)
            Spacer()
          }.padding()
        }.padding(30)
        
        VStack{
          Spacer()
          HStack{
            Spacer()
            
            NavigationLink(destination: {
              ViewTwo()
            }, label: {
              ZStack{
                Image("tenis")
                  .resizable()
                  .scaledToFit()
                  .frame(maxWidth: 100, maxHeight: 100)
                  .padding()
                  .shadow(color: .mint, radius: isAnimating ? 0 : 20)
                  .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: UUID())
                Text("Next")
                  .foregroundStyle(.black)
              }
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
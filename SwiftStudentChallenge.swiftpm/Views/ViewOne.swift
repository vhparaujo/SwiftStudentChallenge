import SwiftUI

struct ViewOne: View {
    
    var body: some View {
        
        VStack {
            
            ZStack {
                Image(Texts.backgroundText)
                    .resizable()
                    .scaledToFit()
                HStack {
                    Text(Texts.text1)
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding()
                }
                .padding()
            }.padding(.horizontal)
            
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    
                    NavigationLink(destination: {
                        ViewTwo().navigationBarBackButtonHidden(true)
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
        
    }
}

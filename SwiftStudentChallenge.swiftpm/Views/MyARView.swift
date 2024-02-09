//
//  ARView.swift
//
//
//  Created by Victor Hugo Pacheco Araujo on 01/02/24.
//

import SwiftUI

struct MyARView: View {
    
    @State var openSheet: Bool = false
    
    var body: some View {
        VStack{
            ARViewContainer().ignoresSafeArea(.all)
                .navigationBarBackButtonHidden(true)
            
        }  .onAppear{
            openSheet.toggle()
        }
        
        .sheet(isPresented: $openSheet) {
            SheetView(openSheet: $openSheet)
        }
    }
}

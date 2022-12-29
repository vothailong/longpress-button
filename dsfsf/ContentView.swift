//
//  ContentView.swift
//  dsfsf
//
//  Created by Vo Thai Long vo on 27/12/2022.
//

import SwiftUI

struct ContentViewdfsdf: View {
    @State var animate = false
    @State var firstAnim = false
    var body: some View {
      VStack {
        ZStack {
            Circle().strokeBorder(lineWidth: 3).frame(width: 40, height: 40)
                //.scaleEffect(self.firstAnim ? 2 : 1)
                .scaleEffect(self.animate ? 2 : (firstAnim ? 1.9 : 1))
//          Circle().fill(colourToShow().opacity(0.35)).frame(width: 30, height: 30).scaleEffect(self.animate ? 1 : 0)
//          Circle().fill(colourToShow().opacity(0.45)).frame(width: 15, height: 15).scaleEffect(self.animate ? 1 : 0)
//          Circle().fill(colourToShow()).frame(width: 16.25, height: 16.25)
        }
        .onAppear {
             self.firstAnim = true
             self.animate = true
            
        }
       // .animation(.easeOut, value: firstAnim)
        .animation(animate ? Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true) : .default, value: animate)
//        .onChange(of: viewModel.colorIndex) { _ in
//          self.animate = false
//          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.animate = true
//          }
//        }
      }
    }
}
func colourToShow() -> Color{
    return .red
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

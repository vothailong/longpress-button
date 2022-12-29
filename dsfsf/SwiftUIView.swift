//
//  SwiftUIView.swift
//  dsfsf
//
//  Created by Vo Thai Long vo on 28/12/2022.
//

import SwiftUI
import Combine
// BOYCOTT on russia! Don't buy, sell, support - HELP TO STOP WAR!
// «Русский военный корабль, иди на хуй!» (c) Ukrainian Frontier Guard
//
// ATTENTION: This is a demo - use it as you wish. Reference is appriciated.
// If you want to thank - buy me coffee: https://secure.wayforpay.com/donate/asperi

import SwiftUI

let recRadius:CGFloat = 60//circle radius, when not recording
let recSquare:CGFloat=0.6//square while recording, a portion compare to circle shape
let startRegcognizeLongPress:CGFloat=0.1
struct ContentView: View {
    private var model = PulsatingViewModel()
    var body: some View {
        PulsatingView(viewModel: model)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.7))
    }
    
    class PulsatingViewModel: ObservableObject {
        @Published var colorIndex = 1
    }
    
    struct PulsatingView: View {
        @GestureState var firstAnim = false
        @GestureState private var longPress = false
        @ObservedObject var viewModel: PulsatingViewModel
        
        @State var first = false
        @State private var isRecording=false
        @State private var isRecordingLongPress=false
        var scale:CGFloat {
            if first == false, longPress == false {
                return 1
            } else  {
                if isRecording {
                    return 1
                } else {
                    return longPress ? 1.8 : 2.5
                }
            }
        }
        var anim:Animation{
            if longPress{
                return Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
            }
            else {
                return  .easeOut(duration: 0.3)
            }
        }
        @State private var cancelLongPress = false
        var body: some View {
            VStack {
                Text("isRecordingLongPress\(isRecordingLongPress.description)")
                Text("isRecording\(isRecording.description)")
                Text("first\(first.description)")
                Text("firstAnim\(firstAnim.description)")
                Text("longpress\(longPress.description)")
                    .padding(.bottom,100)
                Button(action: {
                    print("recbtn tapped")
                    //   vm.actionRec()
                    // isRecording.toggle()
                }, label: {
                    Group{
                        ZStack {
                            let isRecording = self.isRecording || self.isRecordingLongPress
                            RoundedRectangle(cornerRadius: CGFloat(isRecording ? 5 : recRadius/2))
                                .fill(.red)
                                .frame( width:  CGFloat(isRecording ? recRadius*recSquare : recRadius),
                                        height: CGFloat(isRecording ? recRadius*recSquare : recRadius),
                                        alignment: .center)
                                .animation(.linear(duration: 0.15), value: isRecording)
                            
                        }
                        
                    }
                    
                    .frame(width: recRadius - 10, height: recRadius - 10)//to fix size of circle border
                    .padding(16)
                    .overlay(
                        ZStack{
                            Circle()
                                .fill(.black.opacity(0.25))
                            Circle()
                                .strokeBorder(isRecordingLongPress ? .red : .white, lineWidth: 6/scale)
                        }
                            .scaleEffect(scale)
                    )
                    
                    .animation(anim, value: [longPress, isRecordingLongPress, first])
                    .gesture(
                        LongPressGesture(minimumDuration: 0.3)//after this amount, firstanim will be false
                            .updating($firstAnim) { value, state, transaction in
                                state = value
                                
                            }
                            .sequenced(before: LongPressGesture(minimumDuration: .infinity))
                        
                            .updating($longPress) { value, state, transaction in
                                switch value {
                                case .second(true, nil): //the first Gesture has completed and the second is yet undefined
                                    state = true //Update the GestureState
                                    print(".second(true, nil)")
                                default:
                                    break
                                }
                            }
                    )
                    .onChange(of: firstAnim) { value in
                        if value == true{
                            cancelLongPress = false
                            isRecording.toggle()
                            isRecordingLongPress = isRecording//sync
                            DispatchQueue.main.asyncAfter(deadline: .now() + startRegcognizeLongPress) {
                                if firstAnim == true, cancelLongPress == false {
                                    isRecording.toggle()//for square turn to circle
                                    isRecordingLongPress = true//sync, important
                                    first = true//start longpress anim
                                }
                            }
                        } else {//false
                            cancelLongPress = true//to cancel longpress
                            first = false
                        }
                    }
                    .onChange(of: longPress) { value in
                        if !value {
                            cancelLongPress = true//to cancel longpress
                            isRecording = false
                            isRecordingLongPress = false
                            first = false
                        }
                    }
                })
            }
        }
    }
    
}

struct TestPulseColorView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//
//  ContentView.swift
//  ObservedObject
//
//  Created by Alex Pilugins on 16/03/2021.
// ObservedObject: https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-observedobject-to-manage-state-from-external-objects
// ObservedObject: https://www.ioscreator.com/tutorials/swiftui-observable-object-tutorial
//

import SwiftUI

//MARK: - ObservableObject - class UserProgress
class UserProgress: ObservableObject {
    @Published var score = 0
}

struct InnerView: View {
    @ObservedObject var progress: UserProgress

    var body: some View {
        Button("Increase Score") {
            progress.score += 1
        }
    }
}

//MARK: - ObservableObject - class Stopwatch
class Stopwatch: ObservableObject {
    @Published var counter: Int = 0
    
    var timer = Timer()
    func start() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.counter += 1
        }
    }
    func stop() {
        timer.invalidate()
    }
    func reset() {
        counter = 0
        timer.invalidate()
    }
}

func ButtonLook(title: String, bgColor: Color)  -> some View {
    Text(title)
        .padding([.leading, .trailing], 10)
        .padding([.top, .bottom], 5)
        .background(bgColor)
        .foregroundColor(.white)
        .font(.largeTitle)
        .cornerRadius(8)
}

/*
 Tip: It is really important that you use @ObservedObject only with views that were passed in from elsewhere.
 You should not use this property wrapper to create the initial instance of an observable object – that’s what @StateObject is for.
*/
//MARK: - ContentView
struct ContentView: View {
    /*
     the progress property isn’t declared as private.
     This is because bound objects can be used by more than one view, so it’s common to share it openly.
    */
    @StateObject var progress = UserProgress()
    @StateObject var stopwatch = Stopwatch()
    
    var body: some View {
        VStack {
            Spacer()
            Text("Your score is \(progress.score)")
            InnerView(progress: progress)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 2)
                )
            Spacer()
            
            Text("\(self.stopwatch.counter)").font(.largeTitle)
            HStack {
                Button(action: {
                    self.stopwatch.start()
                }) {
                    ButtonLook(title: "Start", bgColor: .green)
                }
                Button(action: {
                    self.stopwatch.stop()
                }) {
                    ButtonLook(title: "Stop", bgColor: .purple)
                }
                Button(action: {
                    self.stopwatch.reset()
                }) {
                    ButtonLook(title: "Reset", bgColor: .red)
                }
            }
            Spacer()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Tako Menteshashvili on 30.09.22.
//

import SwiftUI

struct FlagImage: View{
    let name: String
    
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}


struct ContentView: View {
    @State private var questionCounter = 1
    @State private var showingScore = false
    @State private var showingResult = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var countries = allCountries.shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var selectFlag = -1
    
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US",]
    
    var body: some View {
        
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 00.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.25), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    
                    VStack {
                        
                        Text("tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                        
                    }
                    
                    ForEach(0..<3){ number in
                        Button {
                            flageTapped(number)
                        } label: {
                           FlagImage(name: countries[number])
                                .rotation3DEffect(.degrees(selectFlag == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                .opacity(selectFlag == -1 || selectFlag == number ? 1 : 0.25)
                                .blur(radius: selectFlag == -1 || selectFlag == number ? 0 : 3 )
                                .animation(.default, value: selectFlag)
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score) ")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score \(score)")
        }
        .alert("Game Over!", isPresented: $showingResult) {
            Button("Start Again", action: newGame)
        } message: {
            Text("Your final score was \(score)")
        }
    }
    
    
    func flageTapped(_ number: Int) {
        selectFlag = number
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            
            let theirAnswer = countries[number]
            let needsThe = ["UK", "US"]
            
            if needsThe.contains(theirAnswer) {
                scoreTitle = "Wrong! That's the flag of The \(theirAnswer)"
            } else {
                scoreTitle = "Wrong! That's the flag of \(theirAnswer)"
            }
            if score > 0 {
                score -= 1
            }
        }
        
        if questionCounter == 8 {
            showingResult = true
        } else {
            showingScore = true
        }
    }
    
    
    func askQuestion() {
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionCounter += 1
        selectFlag = -1
        
    }
    
    func newGame() {
        questionCounter = 0
        score = 0
        countries = Self.allCountries
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

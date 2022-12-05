//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Tako Menteshashvili on 30.09.22.
//

import SwiftUI

struct ContentView: View {
    private var gameSize = 15
    @State private var questionCounter = 1
    @State private var showingScore = false
    @State private var showingResult = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var selectedCountry = ""
    @State private var countries = [Country]().shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    private var correctCountry: Country {
        countries[correctAnswer]
    }
    
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
                
                
                if(countries.count > 3) {
                    VStack(spacing: 15) {
                        VStack {
                            Text("tap the flag of")
                                .foregroundStyle(.secondary)
                                .font(.subheadline.weight(.heavy))
                            Text(correctCountry.name.common)
                                .font(.largeTitle.weight(.semibold))
                        }
                        List {
                            ForEach(countries[..<3], id: \.name.common) {country in
                                CountryListItem(country: country, state: getState(country)).onTapGesture {
                                    countryTapped(country);
                                }
                            }
                        }
                        
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                Spacer()
                Spacer()
                
                Text("Score: \(score) / \(gameSize)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
                
            }
            .task {
                await loadData()
            }
            .padding()
            
        }
        
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game over!", isPresented: $showingResult) {
            Button("Start Again", action: newGame)
        } message: {
            Text("Your final score was \(score)")
            
        }
        
    }
    
    func getState(_ country: Country) ->  CountryListItemState {
        if(selectedCountry == country.name.common) {
            return CountryListItemState.selected;
        }
        if(selectedCountry.count > 0) {
            return CountryListItemState.blurred;
        }
        return CountryListItemState.normal;
    }
    
    func countryTapped(_ country: Country) {
        if country.name.common == correctCountry.name.common {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! That's the flag of the \(country.name.common)"
            if score > 0 {
                score -= 1
            }
        }
        
        if questionCounter == gameSize {
            showingResult = true
        } else {
            showingScore = true
        }
    }
    
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2);
        questionCounter += 1
        selectedCountry = ""
    }
    
    func newGame() {
        questionCounter = 0
        score = 0
        askQuestion()
    }
    
    func loadData() async {
        guard let url = URL(string: "https://restcountries.com/v3.1/all?fields=name,flags") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Country].self, from: data) {
                countries = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


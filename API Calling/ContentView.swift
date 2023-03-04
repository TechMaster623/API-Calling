//
//  ContentView.swift
//  API Calling
//
//  Created by Faiz Ali on 2/26/23.
//

import SwiftUI

struct ContentView: View {
    @State private var catFacts = [String]()
    @State private var showAlert = false
    var body: some View {
        NavigationView {
            List(catFacts, id: \.self) { catFact in
                Text(catFact)
                
            }
            .navigationTitle("Random Cat Facts")
            .toolbar {
                Button(action:{
                    Task {
                        await showFacts()
                    }
                }, label: {
                    Image(systemName: "arrow.clockwise")
                })
            }
        }
        .task {
            await showFacts()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the cat fact data"),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    func showFacts() async {
        if let url = URL(string: "https://meowfacts.herokuapp.com/?count=20") {
            if let (data, _) = try? await URLSession.shared.data(from: url) {
                if let decodedResponse = try? JSONDecoder().decode(CatFacts.self, from: data) {
                    catFacts = decodedResponse.facts
                    return
                }
            }
        }
        showAlert = true
    }
}

            
            
            struct ContentView_Previews: PreviewProvider {
                static var previews: some View {
                    ContentView()
                }
            }
            
            struct CatFacts: Identifiable, Codable {
                var id = UUID()
                var facts: [String]
                
                enum CodingKeys: String, CodingKey {
                    case facts = "data"
                }
            }
        

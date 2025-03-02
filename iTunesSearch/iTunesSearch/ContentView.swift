//
//  ContentView.swift
//  iTunesSearch
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct Result: Codable {
    var id: Int
    var team: String
    var opponent: String
    var date: String
    var isHomeGame: Bool
    var score: Score
}

struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        
        List(results, id: \.id) {
            item in
                                    
            HStack {
                VStack(alignment: .leading){
                    Text("\(item.team) vs. \(item.opponent)")
                        .font(.headline)
                    
                    Text("\(item.date)").font(.caption).foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing){
                    Text("\(item.score.unc) - \(item.score.opponent)").font(.headline).foregroundStyle(item.score.unc > item.score.opponent ? Color("UNCBlue") : .secondary)
                    
                    Text(item.isHomeGame ? "Home" : "Away").font(.caption).foregroundStyle(.secondary)
                }
            }
        }
        .task {
            await loadData()
        }

    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
        
            if let decodedResponse = try? JSONDecoder().decode([Result].self, from: data) {
                results = decodedResponse
            }
            
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}

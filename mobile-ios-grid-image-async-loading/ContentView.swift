//
//  ContentView.swift
//  mobile-ios-grid-image-async-loading
//
//  Created by Kiu Ai on 1/16/21.
//

import SwiftUI

struct RSS: Decodable {
    let feed: Feed
}

struct Feed: Decodable {
    let results:[Result]
}

struct Result:Decodable, Hashable {
    let name, releaseDate, copyright: String
}

class GridViewModel: ObservableObject {
    @Published var items = 0..<10
    @Published var results = [Result]()

    init() {
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/cn/ios-apps/top-free/all/100/explicit.json") else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let rss = try JSONDecoder().decode(RSS.self, from: data)
                    print(rss)
                self.results = rss.feed.results
            } catch {
                print("Failed to decode: \(error)")
            }
        }.resume()
    }
}

struct ContentView: View {
    
    @ObservedObject var vm = GridViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12, alignment: .top),
                    GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12, alignment: .top),
                    GridItem(.flexible(minimum: 100, maximum: 200), alignment: .top)
                ], spacing:12, content: {
                    ForEach(vm.results, id: \.self) { result in
                        VStack (alignment: .leading, spacing: 0, content: {
                            Spacer().frame(width: 100, height: 100, alignment: .center).background(Color.blue)
                            Text(result.name).font(.system(size: 10, weight:.semibold))
                            Text(result.releaseDate).font(.system(size: 9, weight:.regular))
                            Text(result.copyright).font(.system(size: 9, weight:.regular)).foregroundColor(.gray)
                        }).padding(.horizontal)
                    }

                }).padding(.horizontal, 12)
                
            }.navigationTitle("Dummy Title")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
 

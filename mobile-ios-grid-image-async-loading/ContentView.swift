//
//  ContentView.swift
//  mobile-ios-grid-image-async-loading
//
//  Created by Kiu Ai on 1/16/21.
//

import SwiftUI
import Kingfisher

struct RSS: Decodable {
    let feed: Feed
}

struct Feed: Decodable {
    let results:[Result]
}

struct Result:Decodable, Hashable {
    let name, releaseDate, copyright, artworkUrl100: String
}

class GridViewModel: ObservableObject {
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
                DispatchQueue.main.async {
                    self.results = rss.feed.results
                }
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
                    GridItem(.flexible(minimum: 50, maximum: 200), spacing: 16, alignment: .top),
                    GridItem(.flexible(minimum: 50, maximum: 200), spacing: 16, alignment: .top),
                    GridItem(.flexible(minimum: 50, maximum: 200), spacing: 16, alignment: .top)
                ], spacing:16, content: {
                    ForEach(vm.results, id: \.self) { result in
                        AppView(result: result)
                    }
                }).padding(.horizontal, 12)
                
            }.navigationTitle("Grid Layout Title")
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
 
struct AppView: View {
    
    let result: Result
    
    var body: some View {
        VStack (alignment: .leading, spacing: 4, content: {
            
            KFImage(URL(string: result.artworkUrl100)).resizable().scaledToFit().cornerRadius(22).overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.gray, lineWidth: 0.5))
            Text(result.name).font(.system(size: 10, weight:.semibold)).padding(.top, 4)
            Text(result.releaseDate).font(.system(size: 9, weight:.regular))
            Text(result.copyright).font(.system(size: 9, weight:.regular)).foregroundColor(.gray)
            
            Spacer()
        })
    }
}

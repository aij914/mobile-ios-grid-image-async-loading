//
//  ContentView.swift
//  mobile-ios-grid-image-async-loading
//
//  Created by Kiu Ai on 1/16/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12),
                    GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12),
                    GridItem(.flexible(minimum: 100, maximum: 200))
                ], spacing:12, content: {
                    ForEach(0..<20, id: \.self) { num in
                        VStack (alignment: .leading, spacing: 0, content: {
                            Spacer().frame(width: 100, height: 100, alignment: .center).background(Color.blue)
                            Text("App Title").font(.system(size: 10, weight:.semibold))
                            Text("Relesase Date").font(.system(size: 9, weight:.regular))
                            Text("Copyright").font(.system(size: 9, weight:.regular)).foregroundColor(.gray)
                        }).padding().background(Color.red)
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
 

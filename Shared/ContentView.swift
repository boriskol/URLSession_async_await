//
//  ContentView.swift
//  Shared
//
//  Created by Borna Libertines on 11/02/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var gifs = MainViewModel()
    
    var body: some View {
        
        NavigationView{
            ScrollViewReader { proxy in
                GeometryReader { geometry in
                    if let tit = self.gifs.gif?.title{
                        NavigationLink(destination: VStack{Text("Detail View \(tit)")}, isActive: self.$gifs.gifDetail) {
                            Text("").frame(width: 0, height: 0)
                        }
                    }
                    VStack(alignment: .leading, spacing: 0, content: {
                        // MARK: Gifs
                        Section(header: VStack(alignment: .leading, spacing: 8){
                            Text("Gifs Traiding").font(.body).foregroundColor(.purple).fontWeight(.bold).padding(.leading)
                        }, content: {
                            List{
                                ForEach(self.gifs.gifs, id: \.id) { gif in
                                    GifCell(gif: gif, geometry: geometry)
                                }
                            }.listStyle(.plain)
                        })
                    })
                    .task{
                        await gifs.loadGift()
                        await gifs.search(search: "love")
                        let searchId = self.gifs.gifs[0].id
                        await gifs.searchGifId(gifID: searchId!)
                    }
                    .refreshable {
                        await gifs.loadGift()
                    }
                }//gio
            }
            .hideNavigationBar()
        }//nav
        .edgesIgnoringSafeArea(.all)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                        
                        // MARK: Gifs
                        Section(header: VStack(alignment: .leading, spacing: 8){
                            Text("Gifs Traiding").font(.body).foregroundColor(.purple).fontWeight(.bold)
                        }, content: {
                            if !self.gifs.gifs.isEmpty{
                                ScrollView(.vertical, showsIndicators: false) {
                                    LazyVStack(alignment: .center, spacing: 8) {
                                        ForEach(self.gifs.gifs, id: \.id) { gif in
                                            LazyVStack(alignment: .leading, spacing: 8) {
                                                if let im = gif.Image{
                                                    HStack(alignment: .center) {
                                                        AsyncImage(url: im, transaction: .init(animation: .spring(response: 1.6))) { phase in
                                                                    switch phase {
                                                                    case .empty:
                                                                        ProgressView()
                                                                            .progressViewStyle(.circular)
                                                                    case .success(let image):
                                                                        image.resizable()
                                                                            .aspectRatio(contentMode: .fill)
                                                                    case .failure:
                                                                        Text("Failed fetching image. Make sure to check your data connection and try again.")
                                                                            .foregroundColor(.red)
                                                                    @unknown default:
                                                                        Text("Unknown error. Please try again.")
                                                                            .foregroundColor(.red)
                                                                    }
                                                                }
                                                        .frame(width: geometry.size.width/4, height: geometry.size.width/4, alignment: .center)
                                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                                        
                                                        if let title = gif.title {
                                                            VStack{
                                                                HStack(alignment: VerticalAlignment.center, spacing: 8) {
                                                                    Text("\(title)")
                                                                }
                                                            }
                                                            Spacer()
                                                        }
                                                    }
                                                }
                                                
                                            }.background(Color.clear)
                                        }
                                    }
                                }.background(Color.clear)
                                    .listRowBackground(Color.clear)
                            }
                        })
                        Spacer()
                    }
                            
                    )}.padding()
                    
                    .task{
                        await gifs.loadGift()
                        await gifs.search(search: "love")
                        let searchId = self.gifs.gifs[0].id
                        await gifs.searchGifId(gifID: searchId!)
                      }
                    .refreshable {
                          
                    }
                    
            }
            .hideNavigationBar()
        }
        .edgesIgnoringSafeArea(.all)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

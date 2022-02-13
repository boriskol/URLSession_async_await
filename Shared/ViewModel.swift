//
//  ViewModel.swift
//  URLSession_async_await
//
//  Created by Borna Libertines on 11/02/22.
//
import Foundation
import Combine
import SwiftUI

// MARK: MainViewModel
/*
 view model for MainViewController
 observe changes in values
 */
@MainActor
class MainViewModel: ObservableObject {
    
    
    @Published var gifs = [GifCollectionViewCellViewModel]()
    @Published var gif: GifViewCellViewModel?
    @Published var gifDetail: Bool = false
    
    // MARK:  Initializer Dependency injestion
    var appiCall: ApiLoader?
    
    init(appiCall: ApiLoader = ApiLoader()){
        self.appiCall = appiCall
    }
    
    
    func loadGift() async {
        
        Task(priority: .background, operation: {
            let fp: APIListResponse? = try? await appiCall?.fetchAPI(urlParams: [Constants.rating: Constants.rating, Constants.limit: Constants.limitNum], gifacces: Constants.trending)
            let d = fp?.data.map({ return GifCollectionViewCellViewModel(id: $0.id, title: $0.title, rating: $0.rating, Image: $0.images?.fixed_height?.url, url: $0.url)
            })
            self.gifs = d!
        })
    }
    
    func search(search: String) async {
        //Task(priority: .userInitiated, operation: {
            let fp: APIListResponse? = try? await appiCall?.fetchAPI(urlParams: [Constants.searchGif: search, Constants.limit: Constants.limitNum], gifacces: Constants.search)
            let d = fp?.data.map({ return GifCollectionViewCellViewModel(id: $0.id, title: $0.title, rating: $0.rating, Image: $0.images?.fixed_height?.url, url: $0.url)
            })
            self.gifs = d!
            
        //})
    }
    func searchGifId(gifID: String) async {
        Task(priority: .userInitiated, operation: {
        let fp: APGifResponse? = try? await appiCall?.fetchAPI(urlParams: [:], gifacces: gifID)
        let d = GifViewCellViewModel(id: fp?.data.id, title: fp?.data.title, rating: fp?.data.rating, Image: fp?.data.images?.fixed_height?.url, video: fp?.data.images?.fixed_height?.mp4, url: fp?.data.url)
                self.gif = d
                self.gifDetail = true
        })
    }

    deinit{
        
        debugPrint("MainViewModel deinit")
    }
}


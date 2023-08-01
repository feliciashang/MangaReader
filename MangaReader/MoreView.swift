//
//  MoreView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-07-05.
//

import SwiftUI
import OAuthSwift

struct MoreView: View {
    let mal = MyAnimeListApi()
    @EnvironmentObject  var viewModel: LibraryViewModel
    @ObservedObject var extensionsViewModel = ExtensionsViewModel()
    @State var code:String = ""
    @State var pages:Array<Extensions.Page> = Array<Extensions.Page>()
    @State var number_of_pages: Int = 0
    @State var downloaded: Bool = false
    @State var arrays:Array<String> = []
    var body: some View {
        NavigationView {
            VStack {
                Button("click") {
                    if extensionsViewModel.pages.count > 0{
                        number_of_pages = extensionsViewModel.pages.count
                        pages = extensionsViewModel.pages
                    }
                }
                Button("download 0") {
                    
                    
                    for page in pages {
                        extensionsViewModel.downloadImage(from: page)
                        let lastComponent = page.url.components(separatedBy: "/").last ?? "cdc"
                        
                        arrays.append(lastComponent)
                    }
                    
                    viewModel.addChapter(cover: "mangaPage", chapter: 0, filename: arrays)
                }
                    if number_of_pages > 0 {
                        ForEach(pages) { page in
                            Text(page.url)
                            pageNumber(page: page, viewModel: extensionsViewModel, model: viewModel)
                        }
                    }
                Button("MyAnimeList") {
                    AlamofireAPI.shared.startOAuth2Login()
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Text("Tracking")
                        .font(.title)
                }
            }
        }
    }
}

struct pageNumber: View {
    let page: Extensions.Page
    let viewModel: ExtensionsViewModel
    let model: LibraryViewModel
    var body: some View {
        NavigationLink(destination: pageView(page: page.url), label:{
            HStack {
                Text(String(page.id))
                Button("Downloaded") {
                    Task {
                        
                        do {
                            viewModel.downloadImage(from: page)
                            let lastComponent = page.url.components(separatedBy: "/").last
                            
//                            model.addChapter(cover: "mangaPage", chapter: page.id, filename: lastComponent!)
                        }
                        
                    }
                    
                }
            }
        })
    }
}
struct pageView: View {
    let page: String
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ScrollView {
                    Group {
                            AsyncImage(url: URL(string: page))
                                .aspectRatio(contentMode: .fit)
                        }
                            
                    }.frame(maxWidth: geo.size.width, minHeight: geo.size.height)
                       
                        
                }
            }
        }
    }
    struct MoreView_Previews: PreviewProvider {
        static var previews: some View {
            let extensions = ExtensionsViewModel()
            MoreView(pages:extensions.pages, number_of_pages: extensions.pages.count)
        }
    }


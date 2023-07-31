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
//    let api = AlamofireAPI()
    @State var code:String = ""
    @State var pages:Array<Extensions.Page> = Array<Extensions.Page>()
    @State var number_of_pages: Int = 0
    @State var downloaded: Bool = false
  //  @State var page = "https://asura.gg/wp-content/uploads/2023/05/EndDesignPSD02.png"
    let oauthswift = OAuth2Swift(consumerKey: "frafe", consumerSecret: "afefef", authorizeUrl: "afeaefeaf", accessTokenUrl: "afefea", responseType: "code")
    var body: some View {
        NavigationView {
            VStack {
                Button("click") {
                    if extensionsViewModel.pages.count > 0{
                        number_of_pages = extensionsViewModel.pages.count
                        pages = extensionsViewModel.pages
                    }
                }
                    if number_of_pages > 0 {
                        ForEach(pages) { page in
                            Text(page.url)
                            pageNumber(page: page, viewModel: extensionsViewModel, model: viewModel)
                        }
                    }
                Button("download"){
                    let url = "https://asura.gg/wp-content/uploads/2023/07/07-214.jpg"
                    extensionsViewModel.downloadImage(from: Extensions.Page(id:4, url: url))
                    downloaded = true
                }
                if downloaded {
                    NavigationLink(destination: downloadpageView(uiimage: extensionsViewModel.load(fileName: "07-214.jpg")!), label: {
                        Text("get picture")
                    })
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
                            let data =  viewModel.downloadImage(from: page)
                            let lastComponent = page.url.components(separatedBy: "/").last
                            print(lastComponent)
                            
                            model.addChapter(cover: "mangaPage", chapter: page.id, filename: lastComponent!)
                        }
                        catch {
                            print(error.localizedDescription)
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
struct downloadpageView: View {
    let uiimage: UIImage
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ScrollView {
                    Group {
                        Image(uiImage: uiimage).resizable()
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


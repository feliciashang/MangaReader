//
//  MoreView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-07-05.
//

import SwiftUI

class SheetMananger: ObservableObject{
    @Published var showSheet = false
    @Published var whichSheet: String? = nil
    @Published var chapters: Array<String>? = nil
    @Published var chapter_numbers: Array<Int>? = nil
    @Published var cover: String? = nil
    @Published var title: String? = nil
    @Published var genre: Array<String>? = nil
}
struct MoreView: View {
    @EnvironmentObject  var viewModel: tempModel
    @ObservedObject var extensionsViewModel = ExtensionsViewModel()
    var body: some View {
        NavigationView {
            List{
                NavigationLink(destination: asuraView(viewModel: extensionsViewModel, model: viewModel), label: {
                    Text("open asura")
                })
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Text("AsuraScan Webtoons")
                        .font(.title)
                }
            }
        }
    }
}

struct asuraView: View {
    let viewModel: ExtensionsViewModel
    let model: tempModel
    @State var changed: Bool = false
    @State var titles: Array<String> = []
    @State var links: Array<String> = []
    @State var page: Int = 1
    var body: some View {
        NavigationView {
            List {
                Button("view popular things") {
                    viewModel.getMangaList(from: "https://asura.nacm.xyz/manga/?page=\(page)") { (value1, value2) in
                        titles = value2
                        links = value1
                        changed = true
                    }
                }
            }.background (
                NavigationLink(destination: listView(viewModel: viewModel, model: model, titles: $titles, links: $links, page: $page), isActive: $changed
                ) {
                    EmptyView()
                }
                    .hidden()
            )
        }
    }
}
    


struct listView: View {
    let viewModel: ExtensionsViewModel
    let model: tempModel
    @Binding var titles: Array<String>
    @Binding var links: Array<String>
    @StateObject var sheetManager = SheetMananger()
    @Binding var page: Int
    @State private var showImageFailureAlert = false
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(0..<links.count, id: \.self) { i in
                        Button(titles[i]) {
                            viewModel.getDescription(from: links[i], for: titles[i]) { (value1, value2, value3, value4, value5) in
                                sheetManager.whichSheet = value1
                                sheetManager.chapters = value2
                                sheetManager.chapter_numbers = value3
                                sheetManager.cover = value4
                                sheetManager.genre = value5
                                sheetManager.showSheet.toggle()
                                sheetManager.title = titles[i]
                            }
                        }
                    }
                }
                HStack {
                    Button("Back") {
                        page -= 1
                        viewModel.getMangaList(from: "https://asura.nacm.xyz/manga/?page=\(page)") { (value1, value2) in
                            titles = value2
                            links = value1
                        }
                    }
                    Spacer()
                    Button("Next") {
                        page += 1
                        viewModel.getMangaList(from: "https://asura.nacm.xyz/manga/?page=\(page)") { (value1, value2) in
                            titles = value2
                            links = value1
                        }
                    }
                }.padding()
            }
            
            .sheet(isPresented: $sheetManager.showSheet, content: {
                coverDetailView(viewModel: viewModel, model: model, description: sheetManager.whichSheet ?? "uhiuhiu", chapters: sheetManager.chapters!, chapter_numbers: sheetManager.chapter_numbers!, cover: sheetManager.cover!, title: sheetManager.title!, genre: sheetManager.genre!)
            })
            .onChange(of: viewModel.onlineImage.failureReason) { reason in
                showImageFailureAlert = (reason != nil)
            }
            .alert(
                "Download Chapter",
                isPresented: $showImageFailureAlert,
                presenting: viewModel.onlineImage.failureReason,
                actions: { reason in
                    Button("OK", role: .cancel) {}
                },
                message: {reason in
                    Text(reason)
                }
            )
        }
    }
}
                
struct coverDetailView: View {
    let viewModel: ExtensionsViewModel
    let model: tempModel
    let description: String
    let chapters: Array<String>
    let chapter_numbers: Array<Int>
    let cover: String
    let title: String
    let genre: Array<String>
    @State var running: ExtensionsViewModel.OnlineImage = .none
    var body: some View {
            ScrollView{
                VStack {
                    Text(title)
                    Text(description)
                    ForEach(0..<chapters.count, id: \.self) { inx in
                        HStack {
                            Text(String(chapter_numbers[inx]))
                            Button("download") {
                                viewModel.downloadCover(from: cover, for: title, chapterNumber: inx )
                                running = viewModel.onlineImage
                                viewModel.downloadImageFromUrl(title: title, chapterNumber: inx, from: chapters[inx])  { value in
                            
                                    model.addStuff(genre: genre, downloaded: true, descri: description, name: title, filename: value, content: "", chapter: chapter_numbers[inx])
                                    
                                    running = viewModel.onlineImage
                                }
                            }
                            if running.isFetching  || viewModel.onlineImage.isFetching {
                                if (running.urlBeingFetched ?? viewModel.onlineImage.urlBeingFetched)! == (inx, title){
                                    ProgressView()
                                }
                            }
                        }
                    }
            }
        }
    }
}


    struct MoreView_Previews: PreviewProvider {
        static var previews: some View {
            MoreView()
        }
    }


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
        @Published var chapter_numbers: Array<String>? = nil
    }
struct MoreView: View {
    @EnvironmentObject  var viewModel: LibraryViewModel
    @ObservedObject var extensionsViewModel = ExtensionsViewModel()
    var body: some View {
        //tried using navigationstack to reduce the extra button
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
    let model: LibraryViewModel
    @State var changed: Bool = false
    @State var titles: Array<String> = []
    @State var links: Array<String> = []
    var body: some View {
        NavigationView {
            List {
                Button("view popular things") {
                    viewModel.getMangaList(from: "https://asura.gg/manga/?page=1&order=update") { (value1, value2) in
                        titles = value2
                        links = value1
                        changed = true
                        
                    }
                }
                NavigationLink(destination: listView(viewModel: viewModel, model: model, titles: $titles, links: $links), label: {
                    Text("click to navigate popular things")
                })
            }
                
            }
        }
    }
    


struct listView: View {
    let viewModel: ExtensionsViewModel
    let model: LibraryViewModel
    @Binding var titles: Array<String>
    @Binding var links: Array<String>
    @StateObject var sheetManager = SheetMananger()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<links.count, id: \.self) { i in
                    Button(titles[i]) {
                        viewModel.getDescription(from: links[i], for: titles[i]) { (value1, value2, value3) in
                            sheetManager.whichSheet = value1
                            sheetManager.chapters = value2
                            sheetManager.chapter_numbers = value3
                            sheetManager.showSheet.toggle()
                        }
                    }
                }
            }
            
            .sheet(isPresented: $sheetManager.showSheet, content: {
                coverDetailView(viewModel: viewModel, model: model, description: sheetManager.whichSheet ?? "uhiuhiu", chapters: sheetManager.chapters!, chapter_numbers: sheetManager.chapter_numbers!)
            })
        }
    }
}
                
struct coverDetailView: View {
    let viewModel: ExtensionsViewModel
    let model: LibraryViewModel
    let description: String
    let chapters: Array<String>
    let chapter_numbers: Array<String>
  //  @Binding var temp: Bool
    var body: some View {
            VStack {
                Text(description)
                ForEach(0..<chapters.count, id: \.self) { inx in
                    Text(chapter_numbers[inx])
                    Button("download") {
                        viewModel.getChapters(from: chapters[inx]) { value in
                            model.addChapter(cover: "mangaPage", chapter: 1, description: description, genre: ["adventure"], filename: value)
                        }
                    }
                }
            }
    }
}


    struct MoreView_Previews: PreviewProvider {
        static var previews: some View {
            let extensions = ExtensionsViewModel()
            MoreView()
        }
    }


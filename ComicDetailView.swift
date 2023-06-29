//
//  ComicDetailView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-28.
//

import SwiftUI

struct ComicDetailView: View {
    var comic: String
    
    @ObservedObject var viewModel: LibraryViewModel
    
    var body: some View {
        VStack {
            Text(comic)
                .fontWeight(.bold)
                .font(.largeTitle)
            List{
                ForEach(viewModel.chapterList[comic] ?? [1], id: \.self) { ids in
                    chapterView(viewModel: viewModel, comic: viewModel.findComic(chapterId: ids))
                }
            }
        }
    }
}

struct chapterView: View {
    let viewModel: LibraryViewModel
    let comic: Model.Comic
    var body: some View {
        NavigationLink(destination: ContentView(comic: comic, viewModel: viewModel), label: {
            Text("Chapter: \(comic.chapter)")
                
        })
    }
}

//struct ComicDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = LibraryViewModel()
//
//        let comic = Model.Comic(id: 1, cover: "cover", chapter: 1, content: "manga")
//        ComicDetailView(comic: comic, viewModel:viewModel)
//    }
//}

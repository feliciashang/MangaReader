//
//  LibraryView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-26.
//

import SwiftUI

struct LibraryView: View {
//    @State var comicsCount = 2
//    @State var comics = ["cover", "endingmaker_cover"]
    var viewModel: LibraryViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Library")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]){
                        ForEach(Array(viewModel.chapterList.keys), id: \.self) { cover in
                            coverView(viewModel: viewModel, comic: cover).aspectRatio(2/3, contentMode: .fit)
                        }
                    }
                }
//                }.frame(minHeight: 70)
            }
        }
    }
}

struct coverView: View {
    let viewModel: LibraryViewModel
    let comic: String
    var body: some View {
        NavigationLink(destination: ComicDetailView(comic: comic, viewModel: viewModel), label: {
            // ZStack {
            Image(comic)
                .renderingMode(.original)
                .resizable()
            
            //   }
        })
    }
    
    
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        let library = LibraryViewModel()
        LibraryView(viewModel: library)
    }
}

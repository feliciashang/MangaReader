//
//  LibraryView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-26.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var viewModel: LibraryViewModel
    @State private var searchText = ""
    var body: some View {
            NavigationView {
                VStack {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]){
                            ForEach(searchResults, id: \.self) { cover in
                                coverView(viewModel: viewModel, comic: cover).aspectRatio(2/3, contentMode: .fit)
                            }
                        }
                    }.searchable(text: $searchText)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading){
                            Text("Library")
                                .font(.title)
                        }
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
//                            Image(systemName: "magnifyingglass")
//                                .foregroundColor(.black)
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .foregroundColor(.black)
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.black)
                        }
                    }
                }.padding(.horizontal)
            }
    }
        var searchResults: [String] {
            if searchText.isEmpty {
                return Array(viewModel.chapterList.keys)
            } else {
                
                return Array(viewModel.chapterList.keys).filter {
                    $0.range(of: searchText, options: .caseInsensitive) != nil
                }
            }
        }
}

struct coverView: View {
    let viewModel: LibraryViewModel
    let comic: String
    var body: some View {
        NavigationLink(destination: ComicDetailView(comic: comic, viewModel: viewModel), label: {
            Image(comic)
                .renderingMode(.original)
                .resizable()
        })
    }  
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        let library = LibraryViewModel()
        return LibraryView(viewModel: library)
    }
}

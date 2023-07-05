//
//  LibraryView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-26.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var viewModel: LibraryViewModel
    @ObservedObject var folderViewModel: FolderViewModel
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            VStack {
                //     ForEach(Array(viewModel.folders.keys), id: \.self) { folder in }
                
                TabView {
                    ForEach(Array(viewModel.folders.keys), id: \.self) { folder_name in
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]){
                                ForEach(searchResults(folder: folder_name), id: \.self) { cover in
                                    coverView(viewModel: viewModel, comic: cover).aspectRatio(2/3, contentMode: .fit)
                                }
                            }}.tabItem {
                                Text(folder_name)
                            }
                    }
                    }.searchable(text: $searchText)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading){
                                Text("Library")
                                    .font(.title)
                            }
                            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .foregroundColor(.black)
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.black)
                            }
                            //     }
                            //                            .tabItem {
                            //                                Text("Master")
                            //
                            //                            }
                            
                        }
                }
                
        }
    }
    
    
    func searchResults(folder: String) -> [String] {
            if searchText.isEmpty {
                return viewModel.folders[folder]!
            } else {
                
                return viewModel.folders[folder]!.filter {
                    $0.range(of: searchText, options: .caseInsensitive) != nil
                }
            }
        }
}

struct FolderTabView: View {
    let comicviewModel: LibraryViewModel
    var folder: String
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]){
                ForEach(comicviewModel.folders[folder] ?? ["Ending Maker"], id: \.self) { cover in
                    coverView(viewModel: comicviewModel, comic: cover).aspectRatio(2/3, contentMode: .fit)
                }
            }
        }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Text("Library")
                        .font(.title)
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundColor(.black)
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.black)
                }
            }
    }
}
struct coverView: View {
    let viewModel: LibraryViewModel
    let comic: String
    
    let folderViewModel: FolderViewModel = FolderViewModel()
    
    var body: some View {
        NavigationLink(destination: ComicDetailView(comic: viewModel.findCover(comic), viewModel: viewModel), label: {
            Image(comic)
                .renderingMode(.original)
                .resizable()
             //   .contextMenu {FolderUIView(folderviewModel: folderViewModel,comic: viewModel.findCover(comic).cover) }
                
        })
    }
}


struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        let library = LibraryViewModel()
        let folder = FolderViewModel()
        return LibraryView(viewModel: library, folderViewModel: folder)
    }
}

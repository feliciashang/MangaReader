//
//  LibraryView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-26.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject  var viewModel: LibraryViewModel
    @State private var searchText = ""
    @State private var selectedTab: Int = 0
    @State var folders: [String] = ["Master", "test"]
    
    func tabs() -> [Tab]{
        var tabs: [Tab] = []
        for name in viewModel.folders.keys {
            tabs.append(.init(title: name))
        }
        return tabs
    }
    var body: some View {
        NavigationView {
            GeometryReader { geo in
            VStack {
                Tabs(tabs: tabs(), geoWidth: geo.size.width, selectedTab: $selectedTab)
                TabView(selection: $selectedTab,
                        content: {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]){
                                ForEach(searchResults(folder: tabs()[selectedTab].title), id: \.self) { cover in
                                    coverView(comic: cover, folders: $folders).aspectRatio(2/3, contentMode: .fit)
                                    
                                }
                            }}.tag(0).padding(.horizontal)
                    }).tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .searchable(text: $searchText)
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
                        
                    }}
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

struct coverView: View {
    @EnvironmentObject  var viewModel: LibraryViewModel
    let comic: String
    @State var isAdding = false
    @State var newFolder: String = ""
    @Binding var folders: [String]
    var body: some View {
        NavigationLink(destination: ComicDetailView(comic: viewModel.findCover(comic), viewModel: viewModel), label: {
            Image(comic)
                .renderingMode(.original)
                .resizable()
                        .contextMenu {
                            VStack {
                                
                                Button(action: {isAdding.toggle()}){
                                    Text("New")
                                    Image(systemName: "plus")
                                    
                                }
                                    ForEach (folders ,id: \.self) { folder in
                                        Button(action: {viewModel.addComic(new_comic:viewModel.findCover(comic).cover , add_to_folder: folder)}) {
                                            Text(folder)
                                            }
                                    }
                                
                            }.id(folders.count)
                        }.alert("Enter new folder name", isPresented: $isAdding) {
                            TextField("Enter your name", text: $newFolder)
                            Button("OK", action: submit)
                            Button("Cancel"){}
                        }
        })
    }
    
    func submit() {
        viewModel.addFolder(newFolder)
        folders.append(newFolder)
        }
}



struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        @State var library = LibraryViewModel()
        return LibraryView()
    }
}

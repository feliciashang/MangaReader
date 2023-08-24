//
//  LibraryView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-26.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject  var viewModel: tempModel
    @State private var searchText = ""
    @State private var selectedTab: Int = 0
 //   @State var folders: [String] = ["ALL"]
    
    func tabs() -> [Tab]{
        var tabs: [Tab] = []
        for folder in viewModel.savedFolders {
            tabs.append(.init(title: folder.name!))
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
                              //  searchResults(folder: tabs()[selectedTab].title
                                if tabs().count > 0 && viewModel.savedFolders != [] && searchResults(folder: tabs()[selectedTab].title).count > 0 {
                                    ForEach(searchResults(folder: tabs()[selectedTab].title), id: \.self) { cover in
                                        coverView(comic: cover).aspectRatio(2/3, contentMode: .fit)
                                        
                                    }
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
        var output: [String] = []
        if searchText.isEmpty {
             let covers  =  viewModel.getCoverfromFolder(folder: folder)
                for cov in covers {
                    output.append(cov.cover!)
                }
          
            return output
            
        }
        return output
//            } else {
//
//                return viewModel.folders[folder]!.filter {
//                    $0.range(of: searchText, options: .caseInsensitive) != nil
//                }
//            }
        }
}

struct coverView: View {
    @EnvironmentObject  var viewModel: tempModel
    let comic: String
    @State var isAdding = false
    @State var newFolder: String = ""
    //var folders: [String]
    var body: some View {
        if let c = viewModel.getCover(name: comic) {
            NavigationLink(destination: ComicDetailView(comic: c, viewModel: viewModel), label: {
                if (c.downloaded == false){
                    Image(comic)
                        .renderingMode(.original)
                        .resizable()
                        .contextMenu() {
                            contextMenu
                        }.alert("Enter new folder name", isPresented: $isAdding) {
                            TextField("Enter your name", text: $newFolder)
                            Button("OK", action: submit)
                            Button("Cancel"){}
                        }
                } else {
                    if let b = viewModel.load(fileName: comic+".jpg") {
                        
                        Image(uiImage: b)
                            .renderingMode(.original)
                            .resizable()
                            .contextMenu() {
                                contextMenu
                            }.alert("Enter new folder name", isPresented: $isAdding) {
                                TextField("Enter your name", text: $newFolder)
                                Button("OK", action: submit)
                                Button("Cancel"){}
                            }
                    }
                }
            })
        }
    }
    
    func submit() {
        viewModel.addFolder(name: newFolder)
      //  folders.append(newFolder)
    }
    
    var contextMenu: some View {
        Section("Add to Folder") {
            Button(action: {isAdding.toggle()}){
                Text("New")
                Image(systemName: "plus")
            }
            ForEach (viewModel.savedFolders ,id: \.self) { folder in
                Button(action: {viewModel.addToFolder(addTo: viewModel.getFolder(name: folder.name ?? "ALL") ?? viewModel.savedFolders[0], cover: viewModel.getCover(name: comic) ?? viewModel.savedCovers[0])}) {
                    Text(folder.name ?? "ALL")
                }
            }
        }.id(viewModel.savedFolders.count)
    }
}



struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        @State var library = LibraryViewModel()
        return LibraryView()
    }
}

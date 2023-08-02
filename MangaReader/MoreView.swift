//
//  MoreView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-07-05.
//

import SwiftUI


struct MoreView: View {
    @EnvironmentObject  var viewModel: LibraryViewModel
    @ObservedObject var extensionsViewModel = ExtensionsViewModel()
    var body: some View {
        //tried using navigationstack to reduce the extra button
        NavigationView {
            List{
                NavigationLink(destination: asuraView(viewModel: extensionsViewModel), label: {
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
    var body: some View {
        VStack {
            Button("view popular things") {
                viewModel.getMangaList(from: "https://asura.gg/manga/?page=1&order=update") { (value1, value2) in
                }
            }
            NavigationLink(destination: listView(viewModel: viewModel), label: {
                Text("enter")
            })
        }
    }
    
}

struct listView: View {
    let viewModel: ExtensionsViewModel
    var body: some View {
        List {
            ForEach(0..<viewModel.titles.count, id: \.self) { i in
                tempView(viewModel: viewModel, i: i)
            }
            
        }
    }
}


struct tempView: View {
    let viewModel: ExtensionsViewModel
    let i: Int
    var body: some View {
        
            Button(viewModel.titles[i]) {
                viewModel.getDescription(from: viewModel.links[i], for: viewModel.titles[i]) { (value1) in
                }
            }
            NavigationLink(destination: coverDetailView(viewModel: viewModel), label: {
                Text("enter")
            })
        }
    
}


struct coverDetailView: View {
    let viewModel: ExtensionsViewModel
    var body: some View {
            VStack {
                Text(viewModel.cover_description)
                Button("click back") {
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


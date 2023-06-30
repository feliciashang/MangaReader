//
//  LibraryView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-26.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var viewModel: LibraryViewModel
    
    var body: some View {
       
            NavigationView {
                VStack {
                    HStack {
                        Text("Library")
                        
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.black)
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.black)
                        
                    }
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]){
                            ForEach(Array(viewModel.chapterList.keys), id: \.self) { cover in
                                coverView(viewModel: viewModel, comic: cover).aspectRatio(2/3, contentMode: .fit)
                            }
                        }
                    }
                }.padding(.horizontal)
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

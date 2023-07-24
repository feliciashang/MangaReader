//
//  HistoryView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-26.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject  var viewModel: LibraryViewModel
    var body: some View {
        
        NavigationView {
            //  ScrollView {
            List{
                ForEach(Array(viewModel.timestamps.keys), id: \.self) { id in
                    timeView(id: id, viewModel: viewModel, time: viewModel.timestamps[id]!)
                }
                
                
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Text("History")
                        .font(.title)
                }
            }
        }
    }
    
}

struct timeView: View {
    var id: Int
    var viewModel: LibraryViewModel
    var time: String
    
    var body: some View {
            NavigationLink(destination: ContentView(comic: viewModel.findComic(chapterId: id), viewModel: viewModel), label: {
                Text(time)
                Text("Chapter: \(viewModel.findComic(chapterId: id).chapter)")
                Image(viewModel.findComic(chapterId: id).cover)
                    .resizable()
                    .frame(maxWidth: 30, maxHeight: 45)

            })

    }
}

//struct HistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = LibraryViewModel()
//        HistoryView(viewModel: viewModel)
//    }
//}

//
//  HistoryView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-26.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: LibraryViewModel
    var body: some View {
        VStack {
            Text("History")
                .fontWeight(.bold)
                .font(.largeTitle)
            List{
                ForEach(Array(viewModel.timestamps.keys), id: \.self) { id in
                    timeView(id: id, viewModel: viewModel, time: viewModel.timestamps[id]!)
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
//        HStack {
//            Text(time)
            NavigationLink(destination: ContentView(comic: viewModel.findComic(chapterId: id), viewModel: viewModel), label: {
                Text(time)
                Text("Chapter: \(viewModel.findComic(chapterId: id).chapter)   Title: \(viewModel.findComic(chapterId: id).cover)")

            })
   //     }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LibraryViewModel()
        HistoryView(viewModel: viewModel)
    }
}

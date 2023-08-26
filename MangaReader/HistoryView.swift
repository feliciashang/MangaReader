//
//  HistoryView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-26.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject  var viewModel: tempModel
    
    var body: some View {

        NavigationView {
            List{
                ForEach(Array(viewModel.savedHistory), id: \.self) { history in
                    timeView(viewModel: viewModel, history: history)
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
    var viewModel: tempModel
    var history: History

    var body: some View {
        NavigationLink(destination: ContentView(comic: viewModel.getComicfromID(id: Int(history.id)), viewModel: viewModel), label: {
            Text(history.time ?? " ")
            Text("Chapter: \(viewModel.getComicfromID(id: Int(history.id)).chapter)")
            if let b = viewModel.load(fileName: viewModel.getComicfromID(id: Int(history.id)).cover!.cover! + ".jpg" ){
                Image(uiImage: b)
                    .resizable()
                    .frame(maxWidth: 30, maxHeight: 45)
            }

            })

    }
}
//
//struct HistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = LibraryViewModel()
//        HistoryView(viewModel: viewModel)
//    }
//}

//
//  HomeView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-26.
//

import SwiftUI

struct HomeView: View {
    @State var selectedView: Int = 1
    
    @ObservedObject var library = LibraryViewModel()
    var body: some View {
        GeometryReader { reader in
            VStack {
                if selectedView == 1 {
                    LibraryView(viewModel: library).frame(minHeight: reader.size.height-50)
                } else if selectedView == 2 {
                    UpdatesView().frame(minHeight: reader.size.height-50)
                } else if selectedView == 3 {
                    HistoryView(viewModel: library).frame(minHeight: reader.size.height-50)
                }
                menu.frame(maxHeight: .infinity)
            }
        }
    }
    
    var menu: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(action: {selectedView = 1}) {
                        Image(systemName: "books.vertical")
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    Button(action: {selectedView = 2}) {
                        Image(systemName: "doc.badge.plus")
   
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    Button(action: {selectedView = 3}) {
                        Image(systemName: "clock")
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    Button(action: {selectedView = 4}) {
                        Image(systemName: "safari")
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    Button(action: {selectedView = 5}) {
                        Image(systemName: "ellipsis")
                            
                    }
                    
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                HStack {
                    Text("Library")
                    Spacer()
                    Text("Updates")
                    Spacer()
                    Text("History")
                    Spacer()
                    Text("Extensions")
                    Spacer()
                    Text("More")
                }
                .font(.footnote)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
       
        HomeView()
    }
}

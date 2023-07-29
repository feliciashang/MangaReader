//
//  HomeView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-26.
//

import SwiftUI

struct HomeView: View {
    @State var selectedView: Int = 1
    
    @StateObject var viewModel: LibraryViewModel = LibraryViewModel()
    @ObservedObject var folderViewModel = FolderViewModel()
    @ObservedObject var extensionsViewModel = ExtensionsViewModel()
    var body: some View {
        NavigationStack {
            TabView {
                LibraryView().environmentObject(viewModel)
                    .tabItem {
                        Text("Home")
                        Image(systemName: "books.vertical")
                    }
                UpdatesView()
                    .tabItem {
                        Text("Updates")
                        Image(systemName: "doc.badge.plus")
                    }
                
                HistoryView().environmentObject(viewModel)
                    .tabItem {
                        Text("History")
                        Image(systemName: "clock")
                    }
                MoreView(pages: extensionsViewModel.pages, number_of_pages: extensionsViewModel.pages.count).environmentObject(viewModel)
                    .tabItem {
                        Text("More")
                        Image(systemName: "ellipsis")
                    }
            }.onAppear {
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithDefaultBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
            
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//       
//        return HomeView()
//    }
//}

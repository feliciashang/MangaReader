//
//  MoreView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-07-05.
//

import SwiftUI


struct TrackerView: View {
    let mal = MyAnimeListApi()
   
    
    var body: some View {
        NavigationView {
            List {
                Button("MyAnimeList") {
                    AlamofireAPI.shared.startOAuth2Login()
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Text("Tracking")
                        .font(.title)
                }
            }
        }
    }
}

    struct TrackerView_Previews: PreviewProvider {
        static var previews: some View {
            let extensions = ExtensionsViewModel()
            TrackerView()
        }
    }


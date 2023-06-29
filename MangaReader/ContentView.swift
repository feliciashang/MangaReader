//
//  ContentView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-22.
//

import SwiftUI

struct ContentView: View {
   
    let comic: Model.Comic
    @ObservedObject var viewModel: LibraryViewModel
    
    let defaultButtonSize: CGFloat = 20
    var body: some View {
        VStack(spacing: 0) {
            documentBody
        }.frame(maxHeight: .infinity, alignment: .bottom)
            .onDisappear(perform: {viewModel.choose(comic: comic)})
        
    }
    var documentBody: some View {
        
        
        GeometryReader { geo in
            ScrollView {
               Group {
//                   if comic == "cover" {
                   Image(comic.content).resizable()
                           .aspectRatio(contentMode: .fit)
//                   } else if comic == "endingmaker_cover" {
//                       Image("ending_maker").resizable()
//                           .aspectRatio(contentMode: .fit)
                 //  }
                
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
                        
                }.frame(maxWidth: geo.size.width, minHeight: geo.size.height)
            }
        }
    }
}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//    
//     //   ContentView(comic: Model.Comic(id: 1, cover: "cover", content: "manga"))
//    }
//}

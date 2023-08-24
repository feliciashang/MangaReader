//
//  ContentView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
   
   // private var items: FetchedResults<Item>
    
   
    let comic: Comic
    @ObservedObject var viewModel: tempModel
    @State private var steadyStateZoomScale: CGFloat = 1
    @GestureState private var gestureZoomScale: CGFloat = 1
    let defaultButtonSize: CGFloat = 20
    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(cs) { c in
//                    Text(c.content ?? "")
//
//                }
//
//            }
//            .listStyle(PlainListStyle())
//            .navigationTitle("Fruits")
//
//        }
//    }
    var body: some View {
        VStack(spacing: 0) {
            documentBody
        }.frame(maxHeight: .infinity, alignment: .bottom)
            .onDisappear(perform: {viewModel.choose(comic)})

    }
    var documentBody: some View {
        GeometryReader { geo in
            ZStack {
                ScrollView {
                    if comic.filename != nil && comic.filename!.count > 0{
                        // if comic.filename != nil && comic.filename!.count > 0 {
                        Group { if comic.downloaded == false {
                            Image(comic.content!).resizable()
                                .aspectRatio(contentMode: .fit)
                        } else {
                            //                 Text(comic.description)
                            
                            ForEach(Array(comic.filename ?? [""]), id: \.self){ filename in
                                if let a = viewModel.load(fileName: filename) {
                                    Image(uiImage: a).resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                            }
                        }
                        }.frame(maxWidth: geo.size.width, minHeight: geo.size.height)
                    }
                } .scaleEffect(zoomScale)
            }.gesture(zoomGesture())
        }
    }
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, _ in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                steadyStateZoomScale *= gestureScaleAtEnd
            }
    }
}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//    
//     //   ContentView(comic: Model.Comic(id: 1, cover: "cover", content: "manga"))
//    }
//}

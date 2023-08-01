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
    @State private var steadyStateZoomScale: CGFloat = 1
    @GestureState private var gestureZoomScale: CGFloat = 1
    let defaultButtonSize: CGFloat = 20
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
                    Group { if comic.downloaded == false {
                        Image(comic.content).resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        ForEach(comic.filename, id: \.self){ filename in
                            Image(uiImage: viewModel.load(fileName: filename)!).resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    }.frame(maxWidth: geo.size.width, minHeight: geo.size.height)
                       
                        
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

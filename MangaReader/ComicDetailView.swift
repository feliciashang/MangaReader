//
//  ComicDetailView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-28.
//

import SwiftUI

struct ComicDetailView: View {
    var comic: String
    @State var isViewed = false
    @ObservedObject var viewModel: LibraryViewModel
    let cornerRadiusCard: CGFloat = 20
    var body: some View {
        VStack(alignment: .leading) {
            Text(comic)
                .fontWeight(.semibold)
                .font(.title)
                .padding(.horizontal)
             Spacer()
            VStack(alignment: .leading) {
                Text("Synopsis:")
                    .font(.subheadline)
                
                Text(viewModel.findCover(comic).description)
                    .multilineTextAlignment(.leading)
                    .lineLimit(isViewed ? 15 : 5)
                    .font(.system(size: 12))
                Button(isViewed ? "Read Less" : "Read More" ) {
                    isViewed.toggle()
                }
                .font(.system(size: 10, weight: .semibold))
            } .padding(.horizontal)
            HStack {
                ForEach(viewModel.findCover(comic).genre, id: \.self) { cur_genre in
                    genreView(genre: cur_genre)
                }
            } .padding(.horizontal)
            List{
                ForEach(viewModel.chapterList[comic] ?? [1], id: \.self) { ids in
                    chapterView(viewModel: viewModel, comic: viewModel.findComic(chapterId: ids))
                }
            }
        }
    }
}
struct genreView: View {
    let genre: String
    var body: some View {
        Text(genre)
            .font(.system(size: 10, weight: .semibold))
            .multilineTextAlignment(.center)
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color(hue: 0.503, saturation: 1.0, brightness: 1.0, opacity: 0.325)).opacity(0.3))
    }
}
struct chapterView: View {
    let viewModel: LibraryViewModel
    let comic: Model.Comic
    var body: some View {
        NavigationLink(destination: ContentView(comic: comic, viewModel: viewModel), label: {
            Text("Chapter \(comic.chapter)")
                
        })
    }
}

struct ComicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LibraryViewModel()

        let comic = "Ending Maker"
        ComicDetailView(comic: comic, viewModel:viewModel)
    }
}

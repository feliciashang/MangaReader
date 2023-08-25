//
//  ComicDetailView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-28.
//

import SwiftUI


struct ComicDetailView: View {
    var comic: Cover
    @State var isViewed = false
    @ObservedObject var viewModel: tempModel
    //var mal: Tracker = Tracker()
    let cornerRadiusCard: CGFloat = 20
    @State private var trackerAlert = false
    var body: some View {
        VStack(alignment: .leading) {
            Text(comic.cover!)
                .fontWeight(.semibold)
                .font(.title)
                .padding(.horizontal)
             Spacer()
            VStack(alignment: .leading) {
                Text("Synopsis:")
                    .font(.subheadline)
                
                Text(comic.descri ?? " ")
                    .multilineTextAlignment(.leading)
                    .lineLimit(isViewed ? 15 : 5)
                    .font(.system(size: 12))
                Button(isViewed ? "Read Less" : "Read More" ) {
                    isViewed.toggle()
                }
                .font(.system(size: 10, weight: .semibold))
            } .padding(.horizontal)
            HStack {
                if comic.genre!.count > 0 {
                    ForEach(Array(comic.genre ?? [""]), id: \.self) { cur_genre in
                        genreView(genre: cur_genre)
                    }
                }
            } .padding(.horizontal)
            HStack {
                Button(action: {
                    viewModel.addTracker(name: comic.cover!) { (value) in
                        if value == false {
                            trackerAlert = true
                        }
                    }
                    
                }){
                    Label("Tracking", systemImage:"plus")
                }
            }
            List{
                if (comic.chapters!.count > 0) {
                    ForEach((comic.chapters?.allObjects as? [Comic])!, id: \.self) { ids in
                        chapterView(viewModel: viewModel, chapter: ids)
                    }
                }
            }
        }
        .alert(
            "Cannot find Comic on MAL",
            isPresented: $trackerAlert,
            actions: {
                Button("OK", role: .cancel) {}
            }
        )
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
    let viewModel: tempModel
    let chapter: Comic
    var body: some View {
        NavigationLink(destination: ContentView(comic: chapter, viewModel: viewModel), label: {
            Text("Chapter \(chapter.chapter)")
        })
    }
}

//struct ComicDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = LibraryViewModel()
//
//        let comic = Cover(id:1, cover: "Ending Maker", chapters:[2,3,4], description: "There are two people who were obssessed with the game, Legend of Heroes 2, and spent thousands of hours on it.The forever number one, Kang Jinho, and the forever number two, Hong Yoohee.One day, when they woke up, they had been reincarnated into their characters within the game…“Hey… You too?”“Hey… Me too!”Legend of Heroes 2’s ending is the end of the human world.However, since there are two of them instead of just one, and not just any two, but the server’s rank one and rank two, things could be different.The journey of the veteran gamers to accomplish the happy ending starts now!", genre: ["Romance", "Video games", "Action"])
//        ComicDetailView(comic: comic, viewModel:viewModel)
//    }
//}

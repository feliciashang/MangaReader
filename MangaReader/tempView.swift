//
//  ContentView.swift
//  ComicReader
//
//  Created by Felicia Shang on 2023-08-05.
//

import SwiftUI


struct tempView: View {
    
    //  private var items: FetchedResults<Item>
    @StateObject var vm = MangaViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Button(action: {vm.deleteEverything()}, label: {
                        Text("Delete")
                    })
                    Button(action: {
                    //    vm.addFolder(name: "ALL")
                        vm.addStuff(genre: ["Adventure"], downloaded: true, descri: "test", name: "Cover3", filename: ["fief"], content: "seffffe", chapter: 1)
                       
                    }, label: {
                        Text("Perform Action")
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.cornerRadius(10))
                    })
                    ScrollView(.horizontal, showsIndicators: true, content: {
                        HStack(alignment: .top) {
                            ForEach(vm.savedFolders) { folder in
                                FolderView(entity: folder)
                            }
                        }
                    })
                    ScrollView(.horizontal, showsIndicators: true, content: {
                        HStack(alignment: .top) {
                            ForEach(vm.savedCovers) { cover in
                                CoversView(entity: cover)
                            }
                        }
                    })
                    
                    ScrollView(.horizontal, showsIndicators: true, content: {
                        HStack(alignment: .top) {
                            ForEach(vm.savedComics) { cover in
                                ComicsView(entity: cover)
                            }
                        }
                    })
                    
                }
                .padding()
            }
        }
        .navigationTitle("Relationships")
    }
}
struct FolderView: View {
    let entity: Folder
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            Text("Name: \(entity.name ?? "")")
                .bold()
            
            if let covers = entity.covers?.allObjects as? [Cover] {
                Text("Covers:")
                    .bold()
                ForEach(covers) { cover in
                    Text(cover.cover ?? "")
                }
            }
            
        })
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }

    
}
struct CoversView: View {
    let entity: Cover
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            Text("Name: \(entity.cover ?? "")")
                .bold()
//            Text("Folder: \(entity.folder ?? "")")
//                .bold()
            if let chapters = entity.chapters?.allObjects as? [Comic] {
                Text("Comics:")
                    .bold()
                ForEach(chapters) { chapter in
                    Text(chapter.description )
                }
            }
            
        })
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.green.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }

    
}

struct ComicsView: View {
    let entity: Comic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            Text("Name: \(entity.id )")
                .bold()
            Text("Number: \(entity.chapter)")
                .bold()
            Text("Folder: \(entity.cover?.cover ?? "")")
                .bold()
            if let chapters = entity.filename  {
                Text("Files:")
                    .bold()
                ForEach(chapters, id: \.self) { chapter in
                    Text(chapter)
                }
            }
        })
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.red.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }

    
}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}

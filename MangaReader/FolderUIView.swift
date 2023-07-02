//
//  FolderUIView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-07-01.
//

import SwiftUI

struct FolderUIView: View {
    @ObservedObject var folderviewModel: FolderViewModel
    @State private var new_folder: String?
    @State var newFolder: String = ""
    @State var isAdding = true
    var comic: Int?
    var body: some View {
        VStack {
            
            contextMenu
        }
        .popover(isPresented: $isAdding) {
            newFolderField
         //   print("hi b")
        }

    }
    
    
    @ViewBuilder
    var contextMenu: some View {
        VStack {
            AnimatedActionButton(title: "New", systemImage: "plus") {
                isAdding = true
            }
            ScrollView {
                ForEach (Array(folderviewModel.folders.keys),id: \.self) { folder in
                        AnimatedActionButton(title: folder) {
                            folderviewModel.addComic(new_comic: comic ?? 1, add_to_folder: folder)
                    }
                }
            }
        }
    }
    
  //  @ViewBuilder
    
    var newFolderField: some View {
        HStack {
            TextField("Enter New Folder Name", text: $newFolder)
            AnimatedActionButton(title: "Enter" ) {
                folderviewModel.addFolder(newFolder)
            }
        }
    }
}


//struct FolderUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderUIView()
//    }
//}

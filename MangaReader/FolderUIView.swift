//
//  FolderUIView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-07-01.
//

import SwiftUI

struct FolderUIView: View {
    @EnvironmentObject  var folderviewModel: LibraryViewModel
    @State private var new_folder: String?
    @State var newFolder: String = ""
    @State var isAdding = false
    var comic: String?
    var body: some View {
        VStack {
            
            contextMenu
        }
    }
    
    
    //@ViewBuilder
    var contextMenu: some View {
        VStack {
            NavigationLink(destination: newFolderField){
                Image(systemName: "plus")
                
            }
            Button(action: {isAdding = true}) {
                Text("new")
            }
            ScrollView {
                Button(action: {print(folderviewModel.folders)}) {
                    
                    Text("click for folders")
                }
               // List{
//                    ForEach (Array(folderviewModel.folders) ,id: \.self) { folder in
//                        Button(action: {folderviewModel.addComic(new_comic: comic ?? "Ending Maker", add_to_folder: folder)}) {
//                            Text(folder)
//                        }
//                 //   }
//                }
            }
        }
    }

    
  //  @ViewBuilder
    
    var newFolderField:  some View {
        HStack {
            TextField("Enter New Folder Name", text: $newFolder)
            AnimatedActionButton(title: "Enter" ) {
             //   folderviewModel.addFolder(newFolder)
            }
        }
    }
}


//struct FolderUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = LibraryViewModel()
//        FolderUIView(folderviewModel: viewModel)
//    }
//}

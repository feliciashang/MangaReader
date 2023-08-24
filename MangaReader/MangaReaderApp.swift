//
//  MangaReaderApp.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-22.
//

import SwiftUI

@main
struct MangaReaderApp: App {
    
  //  let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
        //   tempView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            HomeView()
                .onOpenURL{(url) in
                    AlamofireAPI.shared.processOAuthStep1Response(url: url as NSURL)
                }
        }
    }
}



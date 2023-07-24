//
//  MangaReaderApp.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-22.
//

import SwiftUI

@main
struct MangaReaderApp: App {
    
    
    var body: some Scene {
        WindowGroup {
            
            HomeView()
                .onOpenURL{(url) in
                    AlamofireAPI.shared.processOAuthStep1Response(url: url as NSURL)
                }
        }
    }
}



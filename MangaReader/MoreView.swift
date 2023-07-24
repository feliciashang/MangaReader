//
//  MoreView.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-07-05.
//

import SwiftUI
import OAuthSwift

struct MoreView: View {
    let mal = MyAnimeListApi()
//    let api = AlamofireAPI()
    @State var code:String = ""
    
    let oauthswift = OAuth2Swift(consumerKey: "frafe", consumerSecret: "afefef", authorizeUrl: "afeaefeaf", accessTokenUrl: "afefea", responseType: "code")
    var body: some View {
        NavigationView {
            List{
                Button("MyAnimeList") {
                    AlamofireAPI.shared.startOAuth2Login()
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Text("Tracking")
                        .font(.title)
                }
            }
        }
    }
}
    
    struct MoreView_Previews: PreviewProvider {
        static var previews: some View {
            MoreView()
        }
    }


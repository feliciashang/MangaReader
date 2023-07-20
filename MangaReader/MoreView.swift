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
    @State private var isAuthorized = false
    let oauthswift = OAuth2Swift(consumerKey: "frafe", consumerSecret: "afefef", authorizeUrl: "afeaefeaf", accessTokenUrl: "afefea", responseType: "code")
    var body: some View {
        
        ScrollView {
            Text("More")
                .fontWeight(.bold)
                .font(.largeTitle)
            Link("My Anime List", destination: URL(string: "https://myanimelist.net/profile/bunnyrolls")!)
            if isAuthorized {
                Text(" You are authorized!")
            } else {
                Button("Click me") {
                    // mal.hello()
                    AlamofireAPI.shared.startOAuth2Login()
                    //api.generate()
                }
                TextField("enter", text: $code)
                
                
                Button("token") {
//                 //   var token = mal.generate_new_token(authorisation_code: code)
//                  //  print(token)
//                    mal.print_user_info(access_token: token)
                    AlamofireAPI.shared.processOAuthStep1Response(url: URL(string:code)! as NSURL)
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


//
//  Alamofire.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-07-15.
//

import Foundation
import Alamofire
import SwiftyJSON

class AlamofireAPI
{
    
    static let shared = AlamofireAPI()
    func alamofireManager() -> Session
    {
        let manager = Alamofire.Session.default
        return manager
    }
    var clientID: String = "fed0169f89f0a9c67b0c66d434f22df7"
    let authPath: String = "https://myanimelist.net/v1/oauth2/authorize?client_id=\(CLIENT_ID)&code_challenge=\(codeChallenge)&response_type=code"
    var OAuthToken:String?
    
    func startOAuth2Login() {
        if let authURL:NSURL = NSURL(string: authPath)
        {
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "loadingOAuthToken")
            
            UIApplication.shared.openURL(authURL as URL)
        }
    }
    
    func processOAuthStep1Response(url: NSURL)
    {
        print(url)
        let components = NSURLComponents(url: url as URL, resolvingAgainstBaseURL: false)
        var code:String?
        if let queryItems = components?.queryItems
        {
            for queryItem in queryItems
            {
                if (queryItem.name.lowercased() == "code")
                {
                    code = queryItem.value
                    break
                }
            }
        }
    
        if let receivedCode = code {
            let getTokenPath:String = "https://myanimelist.net/v1/oauth2/token"
            
            let tokenParams = ["client_id": clientID,  "code": receivedCode, "grant_type": "authorization_code", "code_verifier": codeVerifier]
            AF.request( getTokenPath, method: .post, parameters: tokenParams, encoding: URLEncoding.httpBody).responseData  { [self] response in
                switch response.result {
                case .success(let value):
                    print(String(data: value, encoding: .utf8)!)
                    let token = JSON(value)
                    print(token["access_token"])
                    self.OAuthToken = token["access_token"].string
//                    getMyInfo(token:OAuthToken!)
//                    getUserList(token: OAuthToken!)
//                    updateList(token: OAuthToken!)
                case .failure(let error):
                    print(error)
                }
                
            }
            
        }
    }
    
    func getMyInfo(token: String){
        let path:String = "https://api.myanimelist.net/v2/users/@me"
        let header:HTTPHeaders = ["Authorization": "Bearer \(token)"]
        AF.request(path, method: .get, headers: header).responseData {response in
            switch response.result {
            case .success(let value):
                print(String(data: value, encoding: .utf8)!)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getUserList(token: String) {
        let path: String = "https://api.myanimelist.net/v2/users/@me/mangalist?fields=list_status&limit=4"
        let header:HTTPHeaders = ["Authorization": "Bearer \(token)"]
        AF.request(path, method: .get, headers: header).responseData {
            response in
            switch response.result {
            case .success(let value):
                print(String(data:value, encoding: .utf8)!)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateList(id: Int, chapters: Int) {
        let path: String = "https://api.myanimelist.net/v2/manga/\(id)/my_list_status"
        let parameters: Parameters = [
           // "manga_id": 28309,
            "num_chapters_read": chapters
        
        ]
        if let token = self.OAuthToken {
            let header:HTTPHeaders = ["Authorization": "Bearer \(token)"]
            AF.request(path, method: .put, parameters: parameters, headers: header).responseData {
                response in
                switch response.result {
                case .success(let value):
                    print(String(data:value, encoding: .utf8)!)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func findID(original_name: String, name: String, completion: @escaping (Int) -> Void) {
        let path: String = "https://api.myanimelist.net/v2/manga?q=\(name)"
        var id = 0
        if let token = self.OAuthToken {
            let header:HTTPHeaders = ["Authorization": "Bearer \(token)"]
            AF.request(path, method: .get, headers: header).responseData {
                response in
                switch response.result {
                case .success(let value):
                    print(String(data:value, encoding: .utf8)!)
                    let data = JSON(value)
                   // id = data["data"][0]["node"]["id"].int!
                    if let items = data["data"].array {
                        for i in items {
                            if i["node"]["title"].string == original_name {
                                id = i["node"]["id"].int!
                                print(id)
                                completion(id)
                            }
                        }
                    }
                    //return id
                   // self.OAuthToken = token["access_token"].string
                case .failure(let error):
                    print(error)
                    
                }
            }
        }
       
    }
}
        
    
    



//
//  MyAnimeListApi.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-07-06.
//

import Foundation
import CryptoKit

let CLIENT_ID = "fed0169f89f0a9c67b0c66d434f22df7"
precedencegroup ForwardApplication {
    associativity: left
}


// MARK: - PKCE Code Verifier & Code Challenge

enum PKCEError: Error {
    case failedToGenerateRandomOctets
    case failedToCreateChallengeForVerifier
}
infix operator |>: ForwardApplication

func |> <A, B>(a: A, f: (A) -> B) -> B {
    f(a)
}

func |> <A, B>(a: A, f: (A) throws -> B) throws -> B {
    try f(a)
}

//public struct Request<Response> {
//    var method: httpMethod
//    var url: URL?
//    var query: [String: String]?
//    var body: Encodable?
//}

    func generateCryptographicallySecureRandomOctets(count: Int) throws -> [UInt8] {
        var octets = [UInt8](repeating: 0, count: count)
        let status = SecRandomCopyBytes(kSecRandomDefault, octets.count, &octets)
        if status == errSecSuccess { // Always test the status.
            return octets
        } else {
            print("error")
            return octets
        }
    }
    
    
    
    func base64URLEncode<S>(octets: S) -> String where S: Sequence, UInt8 == S.Element {
        let data = Data(octets)
        return data
            .base64EncodedString() // Regular base64 encoder
            .replacingOccurrences(of: "=", with: "") // Remove any trailing '='s
            .replacingOccurrences(of: "+", with: "-") // 62nd char of encoding
            .replacingOccurrences(of: "/", with: "_") // 63rd char of encoding
            .trimmingCharacters(in: .whitespaces)
    }
    
    
    let codeVerifier = try! 32
        |> generateCryptographicallySecureRandomOctets
        |> base64URLEncode

    
    let codeChallenge = codeVerifier
    
    func print_new_authorisation_url(code_challenge: String) {
        let url = "https://myanimelist.net/v1/oauth2/authorize?response_type=code&client_id=" + CLIENT_ID + "&code_challenge=" + code_challenge
        print(code_challenge)
        print("Authorise your application by clicking here: " + url)
    }

    
struct MyAnimeListApi {
    func generate_new_token(authorisation_code: String) -> String{
        let url = URL(string: "https://myanimelist.net/v1/oauth2/token")!
        let datas = [
            "code": authorisation_code,
            "code_verifier": codeVerifier,
            "grant_type": "authorization_code",
            "client_id": CLIENT_ID
        ]
        var return_string:String = ""
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "grant_type=authorization_code&code=" + authorisation_code + "&code_verifier=" + codeVerifier + "&client_id=" + CLIENT_ID
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                
                print(responseJSON)
                let names = responseJSON["access_token"] as? String
                    
                return_string = names ?? ""
                   print("-------------------------------------------------")
                    print(return_string)
            
            }
        }
        task.resume()
        return return_string
        
    }
    
    func print_user_info(access_token: String){
        var request = URLRequest(url: URL(string: "https://api.myanimelist.net/v2/users/@me")!,timeoutInterval: 40)
        request.addValue("", forHTTPHeaderField: "")
        request.addValue("Bearer " + access_token, forHTTPHeaderField: "Authorization")
        request.addValue("Close", forHTTPHeaderField: "Connection")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
              let nsError = error as! NSError
              
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
    }
    
    func hello(){
        
        print_new_authorisation_url(code_challenge: codeChallenge)
        print("enter code")

    }
    
}


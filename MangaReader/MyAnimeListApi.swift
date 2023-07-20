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


//func generate_new_token(authorisation_code: String) {
//    let url = URL(string: "https://myanimelist.net/v1/oauth2/token")!
//    let datas = [
//        "client_id": CLIENT_ID,
//        "code": authorisation_code,
//        "code_verifier": codeVerifier,
//        "grant_type": "authorization_code"
//    ]
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//
//    let jsonData =  try! JSONSerialization.data(withJSONObject: datas, options: .prettyPrinted)
//
//    //After that pass to the http.Body
//
//    // insert json data to the request
//
//    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//
//    request.httpBody = jsonData
//
//    let task = URLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
//        if error != nil{
//            print("Error -> \(error)")
//            return
//        }
//
//        do {
//            let result = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]
//
//            print("Result -> \(result)")
//
//        } catch {
//            print("Error -> \(error)")
//        }
//    }
//
//    task.resume()
//    return task
//}
//
    
struct MyAnimeListApi {
    func generate_new_token(authorisation_code: String) -> String{
        let url = URL(string: "https://myanimelist.net/v1/oauth2/token")!
        let datas = [
            "code": authorisation_code,
            "code_verifier": codeVerifier,
            "grant_type": "authorization_code",
            "client_id": CLIENT_ID
          //  "grant_type": "authorization_code"
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
        
        
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            // Check if Error took place
//            if let error = error {
//                print("Error took place \(error)")
//                return
//            }
//
//            // Read HTTP Response Status code
//            if let response = response as? HTTPURLResponse {
//                print("Response HTTP Status code: \(response.statusCode)")
//            }
//
//            // Convert HTTP Response Data to a simple String
//            if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                print("Response data string:\n \(dataString)")
//                return_string = dataString
//            }
//
//        }
//        task.resume()
//
//        return return_string
        
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
//
//        let url = URL(string: "https://api.myanimelist.net/v2/users/@me")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//     //   request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
//      //  request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue(access_token, forHTTPHeaderField: "Authorization: Bearer ")
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//
//                return
//            }
//            print(data)
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            if let responseJSON = responseJSON as? [String: Any] {
//
//                print(responseJSON)
//                let names = responseJSON["name"] as? String
//
//
//                    print(names)
//
//
//        }
//        task.resume()
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            // Check if Error took place
//            if let error = error {
//                print("Error took place \(error)")
//                return
//            }
//
//            // Read HTTP Response Status code
//            if let response = response as? HTTPURLResponse {
//                print("Response HTTP Status code: \(response.statusCode)")
//            }
//
//            // Convert HTTP Response Data to a simple String
//            if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                print("Response data string:\n \(dataString)")
//            }
//
//        }
     

    }
    
    func hello(){
        
        print_new_authorisation_url(code_challenge: codeChallenge)
        print("enter code")
//        if let authorisation_code = readLine() {
//            print("ok code received, not generating")
//
//            var token = generate_new_token(authorisation_code: authorisation_code)
//            print(token)
//        }
    }
    
}


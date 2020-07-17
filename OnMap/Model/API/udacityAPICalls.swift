//
//  udacityAPICalls.swift
//  OnMap
//
//  Created by Sarah Al-Matawah on 13/07/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import Foundation

class udacityAPICalls {
    
    //MARK: Properties
    static let sessionURL = URLSession.shared
    
    struct sessionData{
        static var sessionId = ""
        static var accountKey = 0
    }
    
    //MARK: API endpoint links
    enum apiEndpoints {
        static let baseURL = "https://onthemap-api.udacity.com/v1"
        
        case studentLocation
        case user
        case session
        
        var stringValue: String {
            switch self {
            case .studentLocation: return apiEndpoints.baseURL + "/StudentLocation"
            case .user: return apiEndpoints.baseURL + "/users"
            case .session: return apiEndpoints.baseURL + "/session"
            }
        }
        
        var url: URL { return URL(string: stringValue)! }
        
    }
    
    //MARK: Get API function
    
    class func downloadAPIRequest<ResponseType: Decodable>(_ url: URL,_ responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void){
        //Request Task Session
        var requestURL = URLRequest(url: url)
        requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestURL.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = sessionURL.dataTask(with: requestURL){ data,response,error in
            guard let data = data else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            let decoder = JSONDecoder()
            
            do{
                let decodedObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async { completion(decodedObject, nil) }
            } catch {
                DispatchQueue.main.async { completion(nil, error) }
            }
            
        }
        task.resume()
    }
    
    //MARK: POST API function
    
    class func uploadAPIRequest<RequestType: Encodable,ResponseType: Decodable>(_ url: URL,_ uploadMethod: HTTPMethods ,_ urlBody: RequestType,_ responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void){
        
        //URL configuration
        var requestURL = URLRequest(url: url)
        requestURL.httpMethod = uploadMethod.rawValue
        requestURL.httpBody = try! JSONEncoder().encode(urlBody)
        requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestURL.addValue("application/json", forHTTPHeaderField: "Accept")
        //Request Task Session
        let task = sessionURL.dataTask(with: requestURL){ data,response,error in
            print(data)
            print(response)
            print(error)
            guard let data = data else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            print(newData)
            print(String(data: newData, encoding: .utf8))
            
            let decoder = JSONDecoder()
            
            do{
                let decodedObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async { completion(decodedObject, nil) }
            } catch {
                DispatchQueue.main.async { completion(nil, error) }
            }
            
        }
        task.resume()
    }
    
    //MARK: Create session
    
    class func createUserSession(_ username: String, _ password: String, completion: @escaping (Bool, Error?) -> Void){
        let urlBody = Udacity(udacity: Auth(username: username, passowrd: password))
        
        uploadAPIRequest(apiEndpoints.session.url, .post, urlBody, SessionPOST.self){ response, error in
            if let response = response {
                sessionData.sessionId = response.session.id
                sessionData.accountKey = response.account.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
            
        }
    }
    
    //MARK: Get User Info
    
    class func getUserInfo(completion: @escaping (User?, Error?) -> Void){
        let url = URL(string: apiEndpoints.user.stringValue + sessionData.sessionId)!
        downloadAPIRequest(url, User.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    //MARK: Delete session
    
    class func deleteUserSession(completion: @escaping () -> Void){
        var request = URLRequest(url: apiEndpoints.session.url)
        request.httpMethod = HTTPMethods.delete.rawValue
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = sessionURL.dataTask(with: request) { data, response, error in
            sessionData.accountKey = 0
            sessionData.sessionId = ""
            DispatchQueue.main.async { completion() }
        }
        task.resume()
    }
    
    //MARK: Retrieve Students locations
    
    class func retrieveStudetLocations(completion: @escaping (StudentInformationData?) -> Void){
        var url = URL(string: apiEndpoints.studentLocation.stringValue+"?limit=100&skip=5&order=-updatedAt")
        downloadAPIRequest(url!, StudentInformationData.self){ response, error in
            if let response = response {
                completion(response)
            }
            completion(nil)
        }
    }
    
    //MARK: Upload Students location
    
    class func uploadStudentLocation(studentInfo: StudentInformation,completion: @escaping (Bool, Error?) -> Void){
        let urlBody = studentInfo
        
        uploadAPIRequest(apiEndpoints.studentLocation.url, .post, urlBody, studentLocationPOST.self){ response, error in
            if let response = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    //MARK: Update Students location
    
    class func updateStudentLocation(_ objectId: String){
        let urlBody = StudentInformation(createdAt: "", firstName: "", lastName: "", latitude: 0.0, longitude: 0.0, mapString: "", mediaURL: "", objectId: "", uniqueKey: "", updatedAt: "")
        var url = apiEndpoints.studentLocation.url
        url.appendPathComponent(objectId)
        uploadAPIRequest(url, .put, urlBody, studentLocationPUT.self){ response, error in
            
        }

    }
    
    
    
    
    
}

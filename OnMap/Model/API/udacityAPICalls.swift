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
        static var accountKey = ""
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
    
    class func downloadAPIRequest<ResponseType: Decodable>(_ url: URL,_ responseType: ResponseType.Type, secure: Bool, completion: @escaping (ResponseType?, Error?) -> Void){
        //Request Task Session
        var requestURL = URLRequest(url: url)
        requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestURL.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = sessionURL.dataTask(with: requestURL){ data,response,error in
            guard let data = data else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            let newData: Data!
            if secure {
                let range = 5..<data.count
                newData = data.subdata(in: range)
            } else {
                newData = data
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
    
    class func uploadAPIRequest<RequestType: Encodable,ResponseType: Decodable>(_ url: URL,_ uploadMethod: HTTPMethods ,_ urlBody: RequestType,_ responseType: ResponseType.Type, secure: Bool, completion: @escaping (ResponseType?, Error?) -> Void){
        
        //URL configuration
        var requestURL = URLRequest(url: url)
        requestURL.httpMethod = uploadMethod.rawValue
        requestURL.httpBody = try! JSONEncoder().encode(urlBody)
        requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestURL.addValue("application/json", forHTTPHeaderField: "Accept")
        //Request Task Session
        let task = sessionURL.dataTask(with: requestURL){ data,response,error in
            guard let data = data else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            let newData: Data!
            if secure {
                let range = 5..<data.count
                newData = data.subdata(in: range)
            } else {
                newData = data
            }
            
            
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
        let urlBody = Udacity(udacity: Auth(username: username, password: password))
        
        uploadAPIRequest(apiEndpoints.session.url, .post, urlBody, SessionPOST.self, secure: true){ response, error in
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
        let url = URL(string: apiEndpoints.user.stringValue + "/" + sessionData.accountKey)!
        let task = sessionURL.dataTask(with: url){ data,response,error in
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            let decoder = JSONDecoder()
            
            do{
                let decodedObject = try decoder.decode(User.self, from: newData!)
                DispatchQueue.main.async { completion(decodedObject, nil) }
            } catch {
                DispatchQueue.main.async { completion(nil, error) }
            }
            
        }
        task.resume()
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
            sessionData.accountKey = ""
            sessionData.sessionId = ""
            DispatchQueue.main.async { completion() }
        }
        task.resume()
    }
    
    //MARK: Retrieve Students locations
    
    class func retrieveStudetLocations(completion: @escaping (StudentInformationData?) -> Void){
        var url = URL(string: apiEndpoints.studentLocation.stringValue+"?limit=100&skip=5&order=-updatedAt")
        downloadAPIRequest(url!, StudentInformationData.self, secure: false){ response, error in
            if let response = response {
                completion(response)
            }
            completion(nil)
        }
    }
    
    //MARK: Upload Students location
    
    class func uploadStudentLocation(studentInfo: StudentInformation,completion: @escaping (Bool, Error?) -> Void){
        let urlBody = "{\"uniqueKey\": \"\(studentInfo.uniqueKey!)\", \"firstName\": \"\(studentInfo.firstName!)\", \"lastName\": \"\(studentInfo.lastName!)\",\"mapString\": \"\(studentInfo.mapString!)\", \"mediaURL\": \"\(studentInfo.mediaURL!)\",\"latitude\": \(studentInfo.latitude!), \"longitude\": \(studentInfo.longitude!)}".data(using: .utf8)
        print(String(data: urlBody!, encoding: .utf8))
        uploadAPIRequest(apiEndpoints.studentLocation.url, .post, urlBody, studentLocationPOST.self, secure: false){ response, error in
            if let response = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    //MARK: Update Students location
    //In course but not being used. Pin added without
    class func updateStudentLocation(studentInfo: StudentInformation, completion: @escaping (Bool, Error?) -> Void){
        let urlBody = studentInfo
        let url = URL(string: apiEndpoints.user.stringValue + "/" + studentInfo.objectId!)!
        print(url)
        uploadAPIRequest(url, .put, urlBody, studentLocationPUT.self, secure: false){ response, error in
            if let response = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }

    }
    
    
    
    
    
}

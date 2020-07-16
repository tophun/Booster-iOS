//
//  EditProfileService.swift
//  Booster
//
//  Created by 노한솔 on 2020/07/16.
//  Copyright © 2020 kimtaehoon. All rights reserved.
//

import Foundation
import Alamofire

struct EditProfileService {
  static let shared = EditProfileService()
  
  private func makeParameter(_ user_name: String, _ user_university: Int, _ user_pw: String) -> Parameters {
    return ["user_name":user_name, "user_university": user_university, "user_pw": user_pw]
  }
  
  func edit(userName: String, userUniv: Int, userPW: String, completion: @escaping(NetworkResult<Any>) -> Void) {
    let header: HTTPHeaders = ["token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkeCI6MSwiaWF0IjoxNTk0MDI1NzE2LCJleHAiOjE1OTc2MjU3MTYsImlzcyI6IkJvb3N0ZXIifQ.FtWfnt4rlyYH9ZV3TyOjLZXOkeR7ya96afmA0zJqTI8"]
    let dataRequest = Alamofire.request(APIConstraints.modifyProfile, method: .put, parameters: makeParameter(userName, userUniv, userPW), encoding: JSONEncoding.default, headers: header)
    
    dataRequest.responseData { dataResponse in
      switch dataResponse.result {
      case .success:
        guard let statusCode = dataResponse.response?.statusCode else{return}
        guard let value = dataResponse.result.value else {return}
        var networkResult: NetworkResult<Any>?
        
        switch statusCode {
        case 200:
          let decoder = JSONDecoder()
          guard let decodedData = try? decoder.decode(StatusData.self, from: value) else {return networkResult = .pathErr}
          if decodedData.status == 200 {
            networkResult = .success(decodedData.data)
          }
          else if decodedData.status == 403 {
            networkResult = .requestErr(decodedData.message)
          }
          else {
            networkResult = .serverErr
          }
        case 400:
          networkResult = .pathErr
        case 500: networkResult = .serverErr
        default: networkResult = .networkFail
        }
        completion(networkResult!)
      case .failure : completion(.networkFail)
      }
    }
  }
}
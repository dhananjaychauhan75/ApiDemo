//
//  WebService.swift
//  CMExpertise Precticle
//
//  Created by Dhananjay chauhan on 31/03/24.
//

import Foundation
import Combine
class WebService {
    //API call with result type
    func apiToGetData<T:Decodable>(resModel:T.Type, url:String,completion : @escaping (Result<T,ApiError>) -> ()){
        guard let sourcesURL = URL(string: url) else {return}
        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let empData = try! jsonDecoder.decode(T.self, from: data)
                completion(.success(empData))
            } else {
                print("hello")
                completion(.failure(ApiError.fail))
            }
        }.resume()
    }
    
    //API call with combine publisher
    func apiToGetDataToCombine<T:Decodable>(resModel:T.Type, url:String) -> AnyPublisher<T,Error>{
        let sourcesURL = URL(string: url)!
           return URLSession.shared.dataTaskPublisher(for: sourcesURL)
                .tryMap { data,response in
                    let jsonDecoder = JSONDecoder()
                    let empData = try! jsonDecoder.decode(T.self, from: data)
                    print("hello")
                    return empData
                }
                .eraseToAnyPublisher()
    }
    
    //API call using asyn await
    func getDataWithWait<T:Decodable>(resModel:T.Type, url:String) async -> Result<T,ApiError> {
        guard let sourcesURL = URL(string: url) else {return .failure(.fail)}
        do {
            let responce = try await URLSession.shared.data(from: sourcesURL)
                let jsonDecoder = JSONDecoder()
            let empData = try! jsonDecoder.decode(T.self, from: responce.0)
                return .success(empData)
        } catch {
            return .failure(.fail)
        }
    }
}


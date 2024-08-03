//
//  WeatherDataViewModel.swift
//  CMExpertise Precticle
//
//  Created by Dhananjay chauhan on 31/03/24.
//

import Foundation
import Combine
class WeatherDataViewModel: ObservableObject {
    
    @Published var list: WeatherResModel?
    
    private var cancalable = Set<AnyCancellable>()
    
    deinit {
        cancalable.forEach({$0.cancel()})
    }
    
    func callWebServiceToGetWeather(apiCompletion: @escaping ((WeatherResModel?)->Void)){
        WebService().apiToGetData(resModel: WeatherResModel.self, url: APIKeys.whether.rawValue) { date in
            switch date {
            case .success(let responce):
                apiCompletion(responce)
            case .failure(_):
                break
            }
        }
    }
    
    //Get data using combine
    func callWebServiceToGetData(){
        WebService().apiToGetDataToCombine(resModel: WeatherResModel.self, url: APIKeys.whether.rawValue).sink { complition in
            switch complition {
            case .finished:
                print("result is ")
            case .failure(let failure):
                print("api fail",failure.localizedDescription)
            }
        } receiveValue: { data in
            print("dayta = ",data.list?.count ?? 0)
            self.list = data
        }.store(in: &cancalable)

    }
    
    func getDataWithAwait() async -> WeatherResModel? {
        let result = await WebService().getDataWithWait(resModel: WeatherResModel.self, url: APIKeys.whether.rawValue)
        switch result {
        case .success(let success):
            return success
        case .failure(_):
            return nil
        }
    }
    
}

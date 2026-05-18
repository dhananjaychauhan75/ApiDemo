//
//  ViewController.swift
//  CMExpertise Precticle
//
//  Created by Dhananjay chauhan on 31/03/24.
//

import UIKit
import Combine
//MARK: - Structure to store data after sorting
struct WData {
    var date: String
    var data: [List]
}


class ViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var tblWeather: UITableView!
    var viewModel = WeatherDataViewModel()
    var arrData = [WData]()
    var bag = Set<AnyCancellable>()
    
    //MARK: - lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // observer for getiing data
        viewModel.$list.sink {[weak self] list in
            self?.refresData(data: list)
        }.store(in: &bag)
        setUpData()
    }

    //MARK: - Custom Method

    /**
     Sets up the initial data sources and triggers the data fetch.

     Configures the table view and initiates the async weather data fetch.
     */
    func setUpData() {
        setTableView()
//        getWeatherData()
//        getDataWithCodeble()
        getDataWithAwait()
    }

    /**
     Refreshes the table view data from the given weather response model.

     Clears any previously stored data before repopulating `arrData` so that
     stale or duplicate entries are never shown. Groups each `List` item by
     its date string and reloads the table view on the main thread.

     - Parameter data: The `WeatherResModel` returned from the API, or `nil`
       if no data is available (in which case the table is cleared).
     */
    func refresData(data: WeatherResModel?) {
        // Reset arrData to prevent duplicate/stale entries on every refresh.
        self.arrData.removeAll()
        for i in data?.list ?? [] {
            let date = i.dtTxt?.getDate() ?? ""
            if let index = self.arrData.firstIndex(where: {$0.date == date}) {
                self.arrData[index].data.append(i)
            } else {
                self.arrData.append(WData(date: date, data: [i]))
            }
        }
        print("total data found = ",self.arrData.count)
        DispatchQueue.main.async {
            self.tblWeather.reloadData()
        }
    }

    /**
     Configures the table view's data source and delegate to this view controller.
     */
    func setTableView() {
        tblWeather.dataSource = self
        tblWeather.delegate = self
    }
}

//MARK: - Web service methods
extension ViewController {
    func getWeatherData() {
        viewModel.callWebServiceToGetWeather { data in
            self.refresData(data: data)
        }
    }
    
    func getDataWithCodeble() {
        viewModel.callWebServiceToGetData()
    }
    
    /**
     Fetches weather data asynchronously using Swift Concurrency (`async/await`).

     The result is published via `viewModel.$list`, which is observed by the
     Combine sink set up in `viewDidLoad`. The sink calls `refresData(data:)`
     automatically, so this method does **not** call it directly — doing so
     would cause each item to be appended twice.
     */
    func getDataWithAwait() {
        Task { @MainActor in
            // Result is published through viewModel.$list;
            // the Combine sink in viewDidLoad handles the UI refresh.
            _ = await viewModel.getDataWithAwait()
        }
    }
}

//MARK: - TableView DataSourse and delegate
extension ViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblWeather.dequeueReusableCell(withIdentifier: "WetherCell", for: indexPath) as! WetherCell
        cell.lblDate.text = arrData[indexPath.row].date
        cell.arrData = arrData[indexPath.row].data
        return cell
    }
}

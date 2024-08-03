//
//  String+Extension.swift
//  CMExpertise Precticle
//
//  Created by Dhananjay chauhan on 31/03/24.
//

import Foundation

extension String {
    func getDate() -> String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: self)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date ?? Date())
    }
    
    func getTime() -> String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: self)
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date ?? Date())
    }
}


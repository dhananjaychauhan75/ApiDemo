//
//  Double+Extension.swift
//  CMExpertise Precticle
//
//  Created by Dhananjay chauhan on 31/03/24.
//

import Foundation
extension Double {
    func getCelcius() -> String {
        let cel = self - 274.15
        return "\(Int(cel)) C"
    }
}

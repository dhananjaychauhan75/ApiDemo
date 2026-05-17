//
//  WetherCell.swift
//  CMExpertise Precticle
//
//  Created by Dhananjay chauhan on 31/03/24.
//

import UIKit

class WetherCell: UITableViewCell {

    //MARK: - Outlet
    @IBOutlet weak var CollectionWether: UICollectionView!
    @IBOutlet weak var lblDate: UILabel!
    var arrData: [List]? {
        didSet {
            CollectionWether.reloadData()
        }
    }
    
    //MARK: - lifecycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        arrData = nil
        lblDate.text = nil
    }
    
    //MARK: - Custom Method
    func setUpData(){
        CollectionWether.dataSource = self
        CollectionWether.delegate = self
    }

}

//MARK: - CollectionView DataSourse and delegate
extension WetherCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataCell", for: indexPath) as! DataCell
        cell.imgWether.image = UIImage(named: "loading")
        
        guard let itemData = arrData?[indexPath.row] else {
            return cell
        }
        
        cell.lblTime.text = itemData.dtTxt?.getTime() ?? ""
        cell.lblCount.text = itemData.main?.temp?.getCelcius() ?? "--"
        
        if let iconCode = itemData.weather?.first?.icon,
           let url = URL(string: "https://openweathermap.org/img/wn/\(iconCode).png") {
            cell.imgWether.load(url: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width / 3) - 2, height: 110)
    }
    
}

//
//  ViewController.swift
//  Webonise
//
//  Created by Uday Mishra on 24/03/19.
//  Copyright © 2019 Uday Mishra. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    let bannerCellId = "bannerCellId"
    let listCellId = "listCellId"
    
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSizeMake(<width>, <height>)
        // Setting the space between cells
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionHeadersPinToVisibleBounds = true
    
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor().colorFromHexString("ffffff")
        cv.showsHorizontalScrollIndicator = false
        
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.allowsMultipleSelection = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    var responseModel: ResponseModel? {
        didSet{
            self.collectionView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(collectionView)
        
        
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        self.view.addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: bannerCellId)
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: listCellId)
        
       getData()
    }
    
    func getData(){
        let url = "http://api.openweathermap.org/data/2.5/find?lat=12.9733694&lon=77.595087&cnt=10&appid=9147adfd1427d9972c0ceabd1d39efbd&units=metric"
        
        
        //Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON {
        Alamofire.request(url, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success(let data):
                let jsonResponse = JSON(data)
                print(jsonResponse)
                do {
                    self.responseModel = try JSONDecoder().decode(ResponseModel.self, from: jsonResponse.rawString()!.data(using: .utf8)!)
                } catch let Error {
                    print("JSON PARSE ERROR",Error)
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }


}

extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.responseModel == nil {
            return 0
        } else {
            return (self.responseModel?.list.count)!
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let list = responseModel?.list[indexPath.item]
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bannerCellId, for: indexPath) as! BannerCell
            cell.cityLabel.text = list?.name
            cell.tempLabel.text = "\((list?.main.temp)!) ° c"
            cell.minTempLabel.text = " Min \((list?.main.tempMin)!) ° c"
            cell.maxTempLabel.text = "Max \((list?.main.tempMax)!) ° c"
            cell.humidityLabel.text = "H \((list?.main.humidity)!) %"
            cell.pressureLabel.text = "P \((list?.main.pressure)!) pa"
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listCellId, for: indexPath) as! ListCell
            cell.titleLabel.text = list?.name
            cell.valueLabel.text = "\((list?.main.temp)!) ° c"
            return cell
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize.init(width: self.collectionView.frame.width, height: 384)
        } else {
            return CGSize.init(width: self.collectionView.frame.width, height: 64)
        }
        
    }
    
    
}

class ListCell: BaseCell {
    
    let titleLabel:UILabel = {
        let lb = UILabel()
        lb.text = "Title Text"
        lb.textColor = .black
//        lb.font = Theme.subHeaderTwoFont
//        lb.numberOfLines = 3
//        lb.textColor = Theme.darkBlack
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let valueLabel:UILabel = {
        let lb = UILabel()
         lb.text = "24° c"
        lb.textColor = .black
        //        lb.font = Theme.subHeaderTwoFont
        //        lb.numberOfLines = 3
        //        lb.textColor = Theme.darkBlack
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return view
    }()
    override func setUpViews() {
       
        addSubview(lineSeparatorView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: lineSeparatorView)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: lineSeparatorView)
        
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        addConstraintsWithFormat(format: "H:|-15-[v0]", views: titleLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: titleLabel)
        
        addConstraintsWithFormat(format: "H:[v0]-15-|", views: valueLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: valueLabel)
        
    }
}
class BannerCell: BaseCell {
    
    
    let cityLabel:UILabel = {
        let lb = UILabel()
        lb.text = "Patna"
        lb.font = lb.font.withSize(20)
        lb.textColor = UIColor().colorFromHexString("ffffff")
        //        lb.font = Theme.subHeaderTwoFont
        //        lb.numberOfLines = 3
        //        lb.textColor = Theme.darkBlack
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let tempLabel:UILabel = {
        let lb = UILabel()
        lb.text = "24° c"
        lb.font = lb.font.withSize(20)
        lb.textColor = UIColor().colorFromHexString("ffffff")
        //        lb.font = Theme.subHeaderTwoFont
        //        lb.numberOfLines = 3
        //        lb.textColor = Theme.darkBlack
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let minTempLabel:UILabel = {
        let lb = UILabel()
        lb.text = "min: 24° c"
        lb.font = lb.font.withSize(15)
        lb.textColor = UIColor().colorFromHexString("ffffff")
        //        lb.font = Theme.subHeaderTwoFont
        //        lb.numberOfLines = 3
        //        lb.textColor = Theme.darkBlack
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let maxTempLabel:UILabel = {
        let lb = UILabel()
        lb.text = "max: 24° c"
        lb.font = lb.font.withSize(15)
        lb.textColor = UIColor().colorFromHexString("ffffff")
        //        lb.font = Theme.subHeaderTwoFont
        //        lb.numberOfLines = 3
        //        lb.textColor = Theme.darkBlack
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let humidityLabel:UILabel = {
        let lb = UILabel()
        lb.text = "H 57%"
        lb.font = lb.font.withSize(15)
        lb.textColor = UIColor().colorFromHexString("ffffff")
        //        lb.font = Theme.subHeaderTwoFont
        //        lb.numberOfLines = 3
        //        lb.textColor = Theme.darkBlack
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let pressureLabel:UILabel = {
        let lb = UILabel()
        lb.text = "P 1013pa"
        lb.font = lb.font.withSize(15)
        lb.textColor = UIColor().colorFromHexString("ffffff")
        //        lb.font = Theme.subHeaderTwoFont
        //        lb.numberOfLines = 3
        //        lb.textColor = Theme.darkBlack
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return view
    }()
    
    let bannerView:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "banner")
        return iv
    }()
    override func setUpViews() {
        
        
        
        addSubview(bannerView)
        
        addSubview(tempLabel)
        addSubview(humidityLabel)
        addSubview(pressureLabel)
        
        addSubview(minTempLabel)
        addSubview(maxTempLabel)
        addSubview(cityLabel)
        addSubview(lineSeparatorView)
        
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: bannerView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: bannerView)
        
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: lineSeparatorView)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: lineSeparatorView)
        
        addConstraintsWithFormat(format: "H:|-25-[v0]", views: tempLabel)
        addConstraintsWithFormat(format: "H:|-25-[v0]", views: humidityLabel)
        addConstraintsWithFormat(format: "H:|-25-[v0]", views: pressureLabel)
        
        addConstraintsWithFormat(format: "H:|-25-[v0]", views: minTempLabel)
        
        addConstraintsWithFormat(format: "H:[v0]-25-|", views: cityLabel)
        addConstraintsWithFormat(format: "V:[v0]-25-|", views: cityLabel)

        addConstraintsWithFormat(format: "V:|-50-[v0]-10-[v1]-10-[v2]-10-[v3]", views: tempLabel,humidityLabel,pressureLabel,minTempLabel)
        
        maxTempLabel.topAnchor.constraint(equalTo: minTempLabel.topAnchor).isActive = true
        maxTempLabel.leadingAnchor.constraint(equalTo: minTempLabel.trailingAnchor, constant:15).isActive = true
        maxTempLabel.bottomAnchor.constraint(equalTo: minTempLabel.bottomAnchor).isActive = true
    }
}

class BaseCell:UICollectionViewCell {
    override init(frame:CGRect) {
        super.init(frame:frame)
        setUpViews()
    }
    func setUpViews() {
        
    }
    required init(coder aDecoder:NSCoder) {
        fatalError("init error")
    }
}


extension UIColor {
    func colorFromHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func visiblity(gone: Bool, dimension: CGFloat = 0.0, attribute: NSLayoutConstraint.Attribute = .height) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = gone ? 0.0 : dimension
            self.layoutIfNeeded()
            self.isHidden = gone
        }
    }
    
}

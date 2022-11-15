//
//  HomeUserProfileCells.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 09/06/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class Cell_ProfileImage  : UITableViewCell {
    @IBOutlet weak var lbl_Username : UILabel!
    @IBOutlet weak var Img_Profile  : SoftUIView!
    @IBOutlet weak var Img_Flag     : SoftUIView!
    var imgView_profile             : UIImageView?
    override func awakeFromNib() {
        super.awakeFromNib()
        Img_Profile.type            = .normal
        Img_Profile.cornerRadius    = Img_Profile.frame.height/2
        Img_Profile.mainColor       = UIColor.paleGray.cgColor
        Img_Profile.darkShadowColor = UIColor.darkShadow.cgColor
        Img_Profile.lightShadowColor = UIColor.lightShadow.cgColor
        Img_Profile.borderWidth     = 2
        Img_Profile.borderColor     = UIColor.white.cgColor
        Img_Profile.isUserInteractionEnabled = false
        
        Img_Flag.type            = .normal
        Img_Flag.cornerRadius    = 10
        Img_Flag.isSelected      = true
        Img_Flag.mainColor       = UIColor.paleGray.cgColor
        Img_Flag.darkShadowColor = UIColor.darkShadow.cgColor
        Img_Flag.lightShadowColor = UIColor.lightShadow.cgColor
        Img_Flag.borderWidth     = 2
        Img_Flag.borderColor     = UIColor.white.cgColor
        
        imgView_profile = Img_Profile.setProfileImage(image: #imageLiteral(resourceName: "SampleUser"),border_Color:.white, border_Width: 2)
    }
}

class Cell_Home_User_Interest    : UITableViewCell {
    @IBOutlet weak var clc_Interest_1 : SharedOffsetCollectionView!
    @IBOutlet weak var clc_Interest_2 : SharedOffsetCollectionView!
    var currentIndex = Int()
    weak var parentobj : UserProfileViewModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        clc_Interest_1.register(UINib(nibName: "Cell_ProfileInterest", bundle: .main), forCellWithReuseIdentifier: "Cell_ProfileInterest")
        clc_Interest_2.register(UINib(nibName: "Cell_ProfileInterest", bundle: .main), forCellWithReuseIdentifier: "Cell_ProfileInterest")
    }
    func loadCollection() {
        clc_Interest_1.tag = 1 + (1000*(currentIndex+1))
        clc_Interest_2.tag = 2 + (1000*(currentIndex+1))
        clc_Interest_1.reloadData()
        clc_Interest_2.reloadData()
        if parentobj?.userList[parentobj?.currentIndex ?? 0].personalInterest?.count ?? 00 == 1 {
            clc_Interest_1.isHidden = true
        }
        else {
            clc_Interest_1.isHidden = false
        }
    }
}
extension Cell_Home_User_Interest : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1+(1000*(currentIndex+1)) {
            if parentobj?.userList.count ?? 0 == 0 {
                return 0
            }
            return (parentobj?.userList[parentobj?.currentIndex ?? 0].personalInterest?.count ?? 0)/2
        }
        else {
            if parentobj?.userList.count ?? 0 == 0 {
                return 0
            }
            return (parentobj?.userList[parentobj?.currentIndex ?? 0].personalInterest?.count ?? 0) - (parentobj?.userList[parentobj?.currentIndex ?? 0].personalInterest?.count ?? 0)/2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_ProfileInterest", for: indexPath) as! Cell_ProfileInterest
        if collectionView.tag == 1+(1000*(currentIndex+1)) {
            if let data = parentobj?.userList[parentobj?.currentIndex ?? 0].personalInterest?[indexPath.row] {
                cell.lbl_title.text = "\(data.interestsIcon ?? "")  \(data.interestName ?? "")"
            }
        }
        else {
            let previousCount = (parentobj?.userList[parentobj?.currentIndex ?? 0].personalInterest?.count ?? 0)/2
            if let data = parentobj?.userList[parentobj?.currentIndex ?? 0].personalInterest?[previousCount + indexPath.row] {
                cell.lbl_title.text = "\(data.interestsIcon ?? "")  \(data.interestName ?? "")"
            }
        }
        cell.lbl_Interest.borderColor = UIColor.white.cgColor
        cell.lbl_Interest.isUserInteractionEnabled = false
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1+(1000*(currentIndex+1)) {
            if let data = parentobj?.userList[parentobj?.currentIndex ?? 0].personalInterest?[indexPath.row] {
                let text = "\(data.interestsIcon ?? "")  \(data.interestName ?? "")"
                let size =  text.size(withAttributes: [NSAttributedString.Key.font: UIFont.AvenirLTPRo_Demi(size: 14)])
                return CGSize(width: size.width+50, height: 47)
            }
        }
        else {
            let previousCount = (parentobj?.userList[parentobj?.currentIndex ?? 0].personalInterest?.count ?? 0)/2
            if let data = parentobj?.userList[parentobj?.currentIndex ?? 0].personalInterest?[previousCount + indexPath.row] {
                let text = "\(data.interestsIcon ?? "")  \(data.interestName ?? "")"
                let size =  text.size(withAttributes: [NSAttributedString.Key.font: UIFont.AvenirLTPRo_Demi(size: 14)])
                return CGSize(width: size.width+50, height: 47)
            }
        }
        return CGSize(width: 128, height: 47)
    }
}
class Cell_Home_User_Goal   : UITableViewCell {
    @IBOutlet weak var clc_Interest_1 : SharedOffsetCollectionView!
    @IBOutlet weak var clc_Interest_2 : SharedOffsetCollectionView!
    var currentIndex = Int()
    weak var parentobj : UserProfileViewModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        clc_Interest_1.register(UINib(nibName: "Cell_ProfileInterest", bundle: .main), forCellWithReuseIdentifier: "Cell_ProfileInterest")
        clc_Interest_2.register(UINib(nibName: "Cell_ProfileInterest", bundle: .main), forCellWithReuseIdentifier: "Cell_ProfileInterest")
    }
    func loadCollection() {
        clc_Interest_1.tag = 1 + (1000*(currentIndex+1))
        clc_Interest_2.tag = 2 + (1000*(currentIndex+1))
        clc_Interest_1.reloadData()
        clc_Interest_2.reloadData()
        if parentobj?.userList[parentobj?.currentIndex ?? 0].careerGoals?.count ?? 0 == 1 {
            clc_Interest_1.isHidden = true
        }
        else {
            clc_Interest_1.isHidden = false
        }
    }
}
extension Cell_Home_User_Goal : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1+(1000*(currentIndex+1)) {
            if parentobj?.userList.count ?? 0 == 0 {
                return 0
            }
            return (parentobj?.userList[parentobj?.currentIndex ?? 0].careerGoals?.count ?? 0)/2
        }
        else {
            if parentobj?.userList.count ?? 0 == 0 {
                return 0
            }
            return (parentobj?.userList[parentobj?.currentIndex ?? 0].careerGoals?.count ?? 0) - (parentobj?.userList[parentobj?.currentIndex ?? 0].careerGoals?.count ?? 0)/2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_ProfileInterest", for: indexPath) as! Cell_ProfileInterest
        if collectionView.tag == 1+(1000*(currentIndex+1)) {
            if let data = parentobj?.userList[parentobj?.currentIndex ?? 0].careerGoals?[indexPath.row] {
                cell.lbl_title.text = "\(data.GoalIcon ?? "")  \(data.goalName ?? "")"
            }
        }
        else {
            let previousCount = (parentobj?.userList[parentobj?.currentIndex ?? 0].careerGoals?.count ?? 0)/2
            if let data = parentobj?.userList[parentobj?.currentIndex ?? 0].careerGoals?[previousCount + indexPath.row] {
                cell.lbl_title.text = "\(data.GoalIcon ?? "")  \(data.goalName ?? "")"
            }
        }
        cell.lbl_Interest.isUserInteractionEnabled = false
        cell.lbl_Interest.borderColor = UIColor.brightPurple.cgColor
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1+(1000*(currentIndex+1)) {
            if let data = parentobj?.userList[parentobj?.currentIndex ?? 0].careerGoals?[indexPath.row] {
                let text = "\(data.GoalIcon ?? "")  \(data.goalName ?? "")"
                let size =  text.size(withAttributes: [NSAttributedString.Key.font: UIFont.AvenirLTPRo_Demi(size: 14)])
                return CGSize(width: size.width+50, height: 47)
            }
        }
        else {
            let previousCount = (parentobj?.userList[parentobj?.currentIndex ?? 0].careerGoals?.count ?? 0)/2
            if let data = parentobj?.userList[parentobj?.currentIndex ?? 0].careerGoals?[previousCount + indexPath.row] {
                let text = "\(data.GoalIcon ?? "")  \(data.goalName ?? "")"
                let size =  text.size(withAttributes: [NSAttributedString.Key.font: UIFont.AvenirLTPRo_Demi(size: 14)])
                return CGSize(width: size.width+50, height: 47)
            }
        }
        return CGSize(width: 128, height: 47)
    }
}

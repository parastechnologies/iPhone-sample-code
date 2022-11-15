//
//  ProfiletabViewCells.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 18/05/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class Cell_ProfileSoundFile : UITableViewCell {
    @IBOutlet weak var view_Image : SoftUIView!
    @IBOutlet weak var lbl_Title  : UILabel!
    @IBOutlet weak var lbl_Desc   : UILabel!
    @IBOutlet weak var btn_More   : UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        view_Image.type             = .normal
        view_Image.cornerRadius     = view_Image.frame.height/2
        view_Image.mainColor        = UIColor.paleGray.cgColor
        view_Image.darkShadowColor  = UIColor.darkShadow.cgColor
        view_Image.lightShadowColor = UIColor.lightShadow.cgColor
        view_Image.borderWidth      = 2
        view_Image.borderColor      = UIColor.white.cgColor
        view_Image.setCellImage(image: #imageLiteral(resourceName: "playIcon"))
        view_Image.isUserInteractionEnabled = false
    }
}
class Cell_ProfileAboutMe_Interest    : UITableViewCell {
    @IBOutlet weak var clc_Interest_1 : SharedOffsetCollectionView!
    @IBOutlet weak var clc_Interest_2 : SharedOffsetCollectionView!
    @IBOutlet weak var view_Empty     : UIView!
    var currentIndex = Int()
    weak var parentobj : ProfileViewModel?
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
        if parentobj?.selectedInterest.count ?? 0 == 1 {
            clc_Interest_1.isHidden = true
        }
        else {
            clc_Interest_1.isHidden = false
        }
    }
}
extension Cell_ProfileAboutMe_Interest : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1+(1000*(currentIndex+1)) {
            return (parentobj?.selectedInterest.count ?? 0)/2
        }
        else {
            return (parentobj?.selectedInterest.count ?? 0) - (parentobj?.selectedInterest.count ?? 0)/2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_ProfileInterest", for: indexPath) as! Cell_ProfileInterest
        if collectionView.tag == 1+(1000*(currentIndex+1)) {
            if let data = parentobj?.selectedInterest[indexPath.row] {
                cell.lbl_title.text = "\(data.interestsIcon ?? "")  \(data.interestName ?? "")"
            }
        }
        else {
            let previousCount = (parentobj?.selectedInterest.count ?? 0)/2
            if let data = parentobj?.selectedInterest[previousCount + indexPath.row] {
                cell.lbl_title.text = "\(data.interestsIcon ?? "")  \(data.interestName ?? "")"
            }
        }
        cell.lbl_Interest.borderColor = UIColor.brightPurple.cgColor
        cell.lbl_Interest.isUserInteractionEnabled = false
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1+(1000*(currentIndex+1)) {
            if let data = parentobj?.selectedInterest[indexPath.row] {
                let text = "\(data.interestsIcon ?? "")  \(data.interestName ?? "")"
                let size =  text.size(withAttributes: [NSAttributedString.Key.font: UIFont.AvenirLTPRo_Demi(size: 14)])
                return CGSize(width: size.width+50, height: 47)
            }
        }
        else {
            let previousCount = (parentobj?.selectedInterest.count ?? 0)/2
            if let data = parentobj?.selectedInterest[previousCount + indexPath.row] {
                let text = "\(data.interestsIcon ?? "")  \(data.interestName ?? "")"
                let size =  text.size(withAttributes: [NSAttributedString.Key.font: UIFont.AvenirLTPRo_Demi(size: 14)])
                return CGSize(width: size.width+50, height: 47)
            }
        }
        return CGSize(width: 128, height: 47)
    }
}
class Cell_ProfileAboutMe_Goal   : UITableViewCell {
    @IBOutlet weak var clc_Interest_1 : SharedOffsetCollectionView!
    @IBOutlet weak var clc_Interest_2 : SharedOffsetCollectionView!
    @IBOutlet weak var view_Empty     : UIView!
    var currentIndex = Int()
    weak var parentobj : ProfileViewModel?
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
        if parentobj?.selectedGoals.count ?? 0 == 1 {
            clc_Interest_1.isHidden = true
        }
        else {
            clc_Interest_1.isHidden = false
        }
    }
}
extension Cell_ProfileAboutMe_Goal : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1+(1000*(currentIndex+1)) {
            return (parentobj?.selectedGoals.count ?? 0)/2
        }
        else {
            return (parentobj?.selectedGoals.count ?? 0) - (parentobj?.selectedGoals.count ?? 0)/2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_ProfileInterest", for: indexPath) as! Cell_ProfileInterest
        if collectionView.tag == 1+(1000*(currentIndex+1)) {
            if let data = parentobj?.selectedGoals[indexPath.row] {
                cell.lbl_title.text = "\(data.GoalIcon ?? "")  \(data.goalName ?? "")"
            }
        }
        else {
            let previousCount = (parentobj?.selectedGoals.count ?? 0)/2
            if let data = parentobj?.selectedGoals[previousCount + indexPath.row] {
                cell.lbl_title.text = "\(data.GoalIcon ?? "")  \(data.goalName ?? "")"
            }
        }
        cell.lbl_Interest.isUserInteractionEnabled = false
        cell.lbl_Interest.borderColor = UIColor.brightPurple.cgColor
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1+(1000*(currentIndex+1)) {
            if let data = parentobj?.selectedGoals[indexPath.row] {
                let text = "\(data.GoalIcon ?? "")  \(data.goalName ?? "")"
                let size =  text.size(withAttributes: [NSAttributedString.Key.font: UIFont.AvenirLTPRo_Demi(size: 14)])
                return CGSize(width: size.width+50, height: 47)
            }
        }
        else {
            let previousCount = (parentobj?.selectedGoals.count ?? 0)/2
            if let data = parentobj?.selectedGoals[previousCount + indexPath.row] {
                let text = "\(data.GoalIcon ?? "")  \(data.goalName ?? "")"
                let size =  text.size(withAttributes: [NSAttributedString.Key.font: UIFont.AvenirLTPRo_Demi(size: 14)])
                return CGSize(width: size.width+50, height: 47)
            }
        }
        return CGSize(width: 128, height: 47)
    }
}
class Cell_ProfileAboutMe_Description  : UITableViewCell {
    @IBOutlet weak var view_Back  : SoftUIView!
    @IBOutlet weak var lbl_desc   : UILabel!
    @IBOutlet weak var view_Empty : UIView!
    override func awakeFromNib() {
        view_Back.type = .normal
        view_Back.cornerRadius = 10
        view_Back.mainColor = UIColor.paleGray.cgColor
        view_Back.darkShadowColor = UIColor.darkShadow.cgColor
        view_Back.lightShadowColor = UIColor.lightShadow.cgColor
    }
}

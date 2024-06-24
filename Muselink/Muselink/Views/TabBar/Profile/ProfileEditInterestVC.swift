//
//  ProfileEditInterestVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 01/02/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//.

import UIKit
class Cell_ProfileCategoryInterest    : UITableViewCell {
    @IBOutlet weak var lbl_Title      : UILabel!
    @IBOutlet weak var lbl_SubTitle   : UILabel!
    @IBOutlet weak var clc_Interest_1 : SharedOffsetCollectionView!
    @IBOutlet weak var clc_Interest_2 : SharedOffsetCollectionView!
    var currentIndex = Int()
    weak var parentobj : ProfileViewModel?
    func loadCollection() {
        clc_Interest_1.tag = 1 + (1000*(currentIndex+1))
        clc_Interest_2.tag = 2 + (1000*(currentIndex+1))
        lbl_Title.text = parentobj?.interestCategoryArray[currentIndex].interestsCategoryName
        if currentIndex == 0 {
            lbl_SubTitle.isHidden = true
        }
        else {
            lbl_SubTitle.isHidden = false
        }
        clc_Interest_1.reloadData()
        clc_Interest_2.reloadData()
    }
}
extension Cell_ProfileCategoryInterest : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1+(1000*(currentIndex+1)) {
            return (parentobj?.interestCategoryArray[currentIndex].interestsData?.count ?? 0)/2
        }
        else {
            return (parentobj?.interestCategoryArray[currentIndex].interestsData?.count ?? 0) - (parentobj?.interestCategoryArray[currentIndex].interestsData?.count ?? 0)/2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_ProfileInterest", for: indexPath) as! Cell_ProfileInterest
        if collectionView.tag == 1+(1000*(currentIndex+1)) {
            cell.lbl_Interest.addTarget(self, action: #selector(action_UpperCollectionCell(sender:)), for: .touchDown)
            if let data = parentobj?.interestCategoryArray[currentIndex].interestsData?[indexPath.row] {
                if parentobj?.selectedInterest.contains(where: { (model) -> Bool in
                    model.interestID == data.interestID
                }) ?? false {
                    cell.lbl_Interest.isSelected = true
                }
                else {
                    cell.lbl_Interest.isSelected = false
                }
                cell.lbl_Interest.tag = indexPath.row
                cell.lbl_title.text = "\(data.interestsIcon ?? "")  \(data.interestName ?? "")"
            }
        }
        else {
            cell.lbl_Interest.addTarget(self, action: #selector(action_DownCollectionCell(sender:)), for: .touchDown)
            let previousCount = (parentobj?.interestCategoryArray[currentIndex].interestsData?.count ?? 0)/2
            if let data = parentobj?.interestCategoryArray[currentIndex].interestsData?[previousCount + indexPath.row] {
                if parentobj?.selectedInterest.contains(where: { (model) -> Bool in
                    model.interestID == data.interestID
                }) ?? false {
                    cell.lbl_Interest.isSelected = true
                }
                else {
                    cell.lbl_Interest.isSelected = false
                }
                cell.lbl_Interest.tag = indexPath.row
                cell.lbl_title.text = "\(data.interestsIcon ?? "")  \(data.interestName ?? "")"
            }
        }
        if currentIndex.quotientAndRemainder(dividingBy: 3).remainder == 0 {
            cell.lbl_Interest.borderColor = UIColor.white.cgColor
        }
        else if currentIndex.quotientAndRemainder(dividingBy: 3).remainder == 1 {
            cell.lbl_Interest.borderColor = UIColor.brightPurple.cgColor
        }
        else if currentIndex.quotientAndRemainder(dividingBy: 3).remainder == 2 {
            cell.lbl_Interest.borderColor = UIColor.skyBlue.cgColor
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1+(1000*(currentIndex+1)) {
            if let data = parentobj?.interestCategoryArray[currentIndex].interestsData?[indexPath.row] {
                let text = "\(data.interestsIcon ?? "")  \(data.interestName ?? "")"
                let size =  text.size(withAttributes: [NSAttributedString.Key.font: UIFont.AvenirLTPRo_Demi(size: 14)])
                return CGSize(width: size.width+50, height: 47)
            }
        }
        else {
            let previousCount = (parentobj?.interestCategoryArray[currentIndex].interestsData?.count ?? 0)/2
            if let data = parentobj?.interestCategoryArray[currentIndex].interestsData?[previousCount + indexPath.row] {
                let text = "\(data.interestsIcon ?? "")  \(data.interestName ?? "")"
                let size =  text.size(withAttributes: [NSAttributedString.Key.font: UIFont.AvenirLTPRo_Demi(size: 14)])
                return CGSize(width: size.width+50, height: 47)
            }
        }
        return CGSize(width: 128, height: 47)
    }
    @objc private func action_UpperCollectionCell(sender:SoftUIView) {
        let rowindex = sender.tag
        if let data = parentobj?.interestCategoryArray[currentIndex].interestsData?[rowindex] {
            if let index = parentobj?.selectedInterest.firstIndex(where: { (model) -> Bool in
                model.interestID == data.interestID
            }) {
                parentobj?.selectedInterest.remove(at: index)
            }
            else {
                parentobj?.selectedInterest.append(data)
            }
        }
        clc_Interest_1.reloadItems(at: [IndexPath(row: rowindex, section: 0)])
    }
    @objc private func action_DownCollectionCell(sender:SoftUIView) {
        let rowindex = sender.tag
        let previousCount = (parentobj?.interestCategoryArray[currentIndex].interestsData?.count ?? 0)/2
        if let data = parentobj?.interestCategoryArray[currentIndex].interestsData?[previousCount + rowindex] {
            if let index = parentobj?.selectedInterest.firstIndex(where: { (model) -> Bool in
                model.interestID == data.interestID
            }) {
                parentobj?.selectedInterest.remove(at: index)
            }
            else {
                parentobj?.selectedInterest.append(data)
            }
        }
        clc_Interest_2.reloadItems(at: [IndexPath(row: rowindex, section: 0)])
    }
}
class Cell_ProfileInterest  : UICollectionViewCell {
    @IBOutlet weak var lbl_Interest    : SoftUIView!
    var lbl_title : UILabel!
    override func awakeFromNib() {
        lbl_Interest.type             = .toggleButton
        lbl_Interest.cornerRadius     = 10
        lbl_Interest.mainColor        = UIColor.paleGray.cgColor
        lbl_Interest.darkShadowColor  = UIColor(white: 0, alpha: 0.20).cgColor
        lbl_Interest.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        lbl_Interest.borderWidth      = 1
        lbl_Interest.borderColor      = UIColor.white.cgColor
        lbl_title   = lbl_Interest.setButtonTitle(font: .AvenirLTPRo_Demi(size: 14), title: "")
    }
}
class ProfileEditInterestVC: BaseClassVC {
    @IBOutlet weak var btn_back       : SoftUIView!
    @IBOutlet weak var btn_Submit     : SoftUIView!
    @IBOutlet weak var tbl_Interest   : UITableView! {
        didSet {
            tbl_Interest.dataSource = viewModel
        }
    }
    var viewModel                     : ProfileViewModel!
    private var selected_Interest_txt : UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVM(model: viewModel)
        viewModel.screenType = .editInterest
        viewModel.didFinishFetch_Ineterest = {[weak self] in
            self?.tbl_Interest.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
        viewModel.fetchInterest()
    }
    private func setUpViews() {
        btn_back.type = .pushButton
        btn_back.addTarget(self, action: #selector(action_Back), for: .touchDown)
        btn_back.cornerRadius = 10
        btn_back.mainColor = UIColor.paleGray.cgColor
        btn_back.darkShadowColor = UIColor(white: 0, alpha: 0.20).cgColor
        btn_back.lightShadowColor = UIColor(white: 1, alpha: 0.70).cgColor
        btn_back.borderWidth = 1
        btn_back.borderColor = UIColor.white.cgColor
        btn_back.setButtonImage(image: #imageLiteral(resourceName: "Back_black"))
        
        btn_Submit.type = .pushButton
        btn_Submit.addTarget(self, action: #selector(action_Submit), for: .touchDown)
        btn_Submit.cornerRadius = ((UIScreen.main.bounds.width-40)*29)/374
        btn_Submit.borderColor = UIColor.paleGray.cgColor
        btn_Submit.borderWidth = 5
        btn_Submit.mainColor   = UIColor.brightPurple.cgColor
        btn_Submit.setButtonTitle(font: .Avenir_Medium(size: 25), title: "Submit",titleColor: .white)
    }
    @objc private func action_Submit() {
        if viewModel.isValid {
            viewModel.updateInterest()
            viewModel.didFinishInterestUpdate = {[weak self] in
                DispatchQueue.main.async {
                    self?.showSuccessMessages(message: "Interest update successfully.")
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        else {
            showErrorMessages(message: viewModel.brokenRules.first?.message ?? "")
        }
    }
    @objc private func action_OK() {
        
    }
}

//
//  ProfileEditGoalVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 01/02/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class ProfileEditGoalVC: BaseClassVC {
    @IBOutlet weak var btn_back      : SoftUIView!
    @IBOutlet weak var btn_Submit    : SoftUIView!
    @IBOutlet weak var clc_Goal      : UICollectionView!
    var viewModel                    : ProfileViewModel!
    
    private var selected_Goal_txt : UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVM(model: viewModel)
        viewModel.screenType = .editGoal
        viewModel.didFinishFetch_Goal = {[weak self] in
            self?.clc_Goal.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
        viewModel.fetchGoals()
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
            viewModel.updateGoal()
            viewModel.didFinishGoalUpdate = {[weak self] in
                DispatchQueue.main.async {
                    self?.showSuccessMessages(message: "Goals update successfully.")
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        else {
            showErrorMessages(message: viewModel.brokenRules.first?.message ?? "")
        }
    }
}
extension ProfileEditGoalVC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.goalsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_ProfileInterest", for: indexPath) as! Cell_ProfileInterest
        cell.lbl_Interest.addTarget(self, action: #selector(action_Cell(sender:)), for: .touchDown)
        let data = viewModel.goalsArray[indexPath.row]
        if viewModel.selectedGoals.contains(where: { (model) -> Bool in
            model.goalID == data.goalID
        }) {
            cell.lbl_Interest.isSelected = true
        }
        else {
            cell.lbl_Interest.isSelected = false
        }
        cell.lbl_Interest.tag = indexPath.row
        cell.lbl_title.text = "\(data.GoalIcon ?? "")  \(data.goalName ?? "")"
        cell.lbl_Interest.borderColor = UIColor.brightPurple.cgColor
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (UIScreen.main.bounds.width-40)/2 - 10
        return CGSize(width: size, height: 50)
    }
    @objc private func action_Cell(sender:SoftUIView) {
        let rowindex = sender.tag
        let data = viewModel.goalsArray[rowindex]
        if let index = viewModel.selectedGoals.firstIndex(where: { (model) -> Bool in
            model.goalID == data.goalID
        }) {
            viewModel.selectedGoals.remove(at: index)
        }
        else {
            viewModel.selectedGoals.append(data)
        }
    }
}

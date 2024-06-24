//
//  PremiumPlanDetalVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 15/01/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class PremiumPlanDetalVC: BaseClassVC {
    @IBOutlet weak var btn_Continue           : SoftUIView!
    @IBOutlet weak var view_TimerSelectedback : SoftUIView!
    @IBOutlet weak var view_TimerBack         : SoftUIView!
    @IBOutlet weak var btn_Plan_1             : SoftUIView!
    @IBOutlet weak var btn_Plan_2             : SoftUIView!
    @IBOutlet weak var slideShow              : ImageSlideshow!
    @IBOutlet      var view_Dots              : [SoftUIView]!
    private lazy var dot_selected : UIView = {
        let view = UIView(frame: CGRect(x: 5, y: 5, width: 11, height: 11))
        view.backgroundColor = UIColor.brightPurple
        view.layer.cornerRadius = 5.5
        view.clipsToBounds = true
        return view
    }()
    private var plan_1_Text        : UILabel!
    private var plan_2_Text        : UILabel!
    private var layer_Corner_Plan_1 : CAShapeLayer!
    private var layer_Corner_Plan_2 : CAShapeLayer!
    private var viewModel : PremiumViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PremiumViewModel()
        setUpVM(model: viewModel)
        slideShow.backgroundColor = UIColor.clear
        slideShow.slideshowInterval = 2
        slideShow.contentScaleMode = .scaleAspectFit
        slideShow.currentPageChanged = {[unowned self](page) in
            for vew in self.view_Dots {
                if vew.tag == page+1 {
                    UIView.animate(withDuration: 0.5) {
                        vew.addSubview(dot_selected)
                    }
                }
            }
        }
        viewModel.didFinishFetch = {[weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let attributedText_1_1 = NSAttributedString.init(string: (self.viewModel.products.first?.localizedPrice ?? "$0") + "\n", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Demi(size: 20),NSAttributedString.Key.foregroundColor : UIColor.white])
                let attributedText_1_2 = NSAttributedString.init(string: "for 1 month", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Regular(size: 18),NSAttributedString.Key.foregroundColor : UIColor.white])
                let combinationText_1 = NSMutableAttributedString()
                combinationText_1.append(attributedText_1_1)
                combinationText_1.append(attributedText_1_2)
                self.plan_1_Text.attributedText = combinationText_1
                
                let attributedText_2_1 = NSAttributedString.init(string: (self.viewModel.products.last?.localizedPrice ?? "$0") + "\n", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Demi(size: 20),NSAttributedString.Key.foregroundColor : UIColor.brightPurple])
                let attributedText_2_2 = NSAttributedString.init(string: "for 12 months\n", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Regular(size: 18),NSAttributedString.Key.foregroundColor : UIColor.white])
                let attributedText_2_3 = NSAttributedString.init(string: "Save 38%", attributes: [NSAttributedString.Key.font:UIFont.italicSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.skyBlue])
                let combinationText_2 = NSMutableAttributedString()
                combinationText_2.append(attributedText_2_1)
                combinationText_2.append(attributedText_2_2)
                combinationText_2.append(attributedText_2_3)
                self.plan_2_Text.attributedText = combinationText_2
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
        viewModel.fetchProductList()
    }
    private func setUpViews() {
        view_TimerBack.type = .normal
        view_TimerBack.cornerRadius = 10
        view_TimerBack.mainColor = UIColor.darkBackGround.cgColor
        view_TimerBack.darkShadowColor = UIColor.black.cgColor
        view_TimerBack.lightShadowColor = UIColor.darkGray.cgColor

        view_TimerSelectedback.type = .normal
        view_TimerSelectedback.isSelected = true
        view_TimerSelectedback.cornerRadius = 10
        view_TimerSelectedback.mainColor = UIColor.darkBackGround.cgColor
        view_TimerSelectedback.darkShadowColor = UIColor.black.cgColor
        view_TimerSelectedback.lightShadowColor = UIColor.darkGray.cgColor
        view_TimerSelectedback.setButtonTitle(font: .AvenirLTPRo_Bold(size: 22), title: "11 : 45 : 53", titleColor: .skyBlue)

        
        btn_Plan_1.type = .pushButton
        btn_Plan_1.addTarget(self, action: #selector(action_Plan_1), for: .touchDown)
        btn_Plan_1.cornerRadius = 10
        btn_Plan_1.mainColor = UIColor.darkBackGround.cgColor
        btn_Plan_1.darkShadowColor = UIColor.black.cgColor
        btn_Plan_1.lightShadowColor = UIColor.darkGray.cgColor
        btn_Plan_1.borderColor = UIColor.clear.cgColor
        btn_Plan_1.borderWidth = 1
        plan_1_Text = btn_Plan_1.setButtonTitle(font: .systemFont(ofSize: 10), title: "")

        layer_Corner_Plan_1 = btn_Plan_1.addLeftSideCornerView()
        layer_Corner_Plan_1.fillColor = UIColor.appRed.cgColor
        
        btn_Plan_2.type = .pushButton
        btn_Plan_2.addTarget(self, action: #selector(action_Plan_2), for: .touchDown)
        btn_Plan_2.cornerRadius = 10
        btn_Plan_2.mainColor = UIColor.darkBackGround.cgColor
        btn_Plan_2.darkShadowColor = UIColor.black.cgColor
        btn_Plan_2.lightShadowColor = UIColor.darkGray.cgColor
        btn_Plan_2.borderColor = UIColor.brightPurple.cgColor
        btn_Plan_2.borderWidth = 1
        plan_2_Text = btn_Plan_2.setButtonTitle(font: .systemFont(ofSize: 10), title: "")
        layer_Corner_Plan_2 = btn_Plan_2.addLeftSideCornerView()
        layer_Corner_Plan_2.fillColor = UIColor.brightPurple.cgColor
        
        btn_Continue.type = .pushButton
        btn_Continue.addTarget(self, action: #selector(action_Continue), for: .touchDown)
        btn_Continue.cornerRadius = btn_Continue.frame.height/2
        btn_Continue.mainColor = UIColor.darkBackGround.cgColor
        btn_Continue.darkShadowColor = UIColor.black.cgColor
        btn_Continue.lightShadowColor = UIColor.darkGray.cgColor
        btn_Continue.borderWidth = 2
        btn_Continue.borderColor = UIColor.purple.cgColor
        btn_Continue.setButtonTitle(font: .Avenir_Medium(size: 20), title: "Continue",titleColor: .paleGray)
        
        slideShow.setImageInputs([ImageSource.init(image: #imageLiteral(resourceName: "slide")),ImageSource.init(image: #imageLiteral(resourceName: "slide_1")),ImageSource.init(image: #imageLiteral(resourceName: "slide_2")),ImageSource.init(image: #imageLiteral(resourceName: "slide_3")),ImageSource.init(image: #imageLiteral(resourceName: "slide_4")),ImageSource.init(image: #imageLiteral(resourceName: "slide_6")),ImageSource.init(image: #imageLiteral(resourceName: "slide_5"))])
        for view in view_Dots {
            view.type             = .normal
            view.isSelected       = true
            view.cornerRadius     = 11
            view.mainColor     = UIColor.darkBackGround.cgColor
            view.darkShadowColor = UIColor.black.cgColor
            view.lightShadowColor = UIColor.darkGray.cgColor
        }
        view_Dots.first?.addSubview(dot_selected)
    }
    @objc private func action_Continue() {
        viewModel.purchase()
        viewModel.didFinishPayement = {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[unowned self] in
                guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "PremiumThankYouSupportVC") as? PremiumThankYouSupportVC else {
                    return
                }
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    @IBAction func action_Close() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    @objc private func action_Plan_1() {
        viewModel.selectedSubscription = .Monthly
        btn_Plan_1.borderColor = UIColor.brightPurple.cgColor
        let attributedText_1_1 = NSAttributedString.init(string: (self.viewModel.products.first?.localizedPrice ?? "$0") + "\n", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Demi(size: 20),NSAttributedString.Key.foregroundColor : UIColor.brightPurple])
        let attributedText_1_2 = NSAttributedString.init(string: "for 1 month", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Regular(size: 18),NSAttributedString.Key.foregroundColor : UIColor.white])
        let combinationText_1 = NSMutableAttributedString()
        combinationText_1.append(attributedText_1_1)
        combinationText_1.append(attributedText_1_2)
        plan_1_Text.attributedText = combinationText_1
        layer_Corner_Plan_1.fillColor = UIColor.brightPurple.cgColor
        
        btn_Plan_2.borderColor = UIColor.clear.cgColor
        let attributedText_2_1 = NSAttributedString.init(string: (self.viewModel.products.last?.localizedPrice ?? "$0") + "\n", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Demi(size: 20),NSAttributedString.Key.foregroundColor : UIColor.white])
        let attributedText_2_2 = NSAttributedString.init(string: "for 12 months\n", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Regular(size: 18),NSAttributedString.Key.foregroundColor : UIColor.white])
        let attributedText_2_3 = NSAttributedString.init(string: "Save 38%", attributes: [NSAttributedString.Key.font:UIFont.italicSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.skyBlue])
        let combinationText_2 = NSMutableAttributedString()
        combinationText_2.append(attributedText_2_1)
        combinationText_2.append(attributedText_2_2)
        combinationText_2.append(attributedText_2_3)
        plan_2_Text.attributedText = combinationText_2
        layer_Corner_Plan_2.fillColor = UIColor.appRed.cgColor
    }
    @objc private func action_Plan_2() {
        viewModel.selectedSubscription = .Yearly
        btn_Plan_1.borderColor = UIColor.clear.cgColor
        let attributedText_1_1 = NSAttributedString.init(string: (self.viewModel.products.first?.localizedPrice ?? "$0") + "\n", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Demi(size: 20),NSAttributedString.Key.foregroundColor : UIColor.white])
        let attributedText_1_2 = NSAttributedString.init(string: "for 1 month", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Regular(size: 18),NSAttributedString.Key.foregroundColor : UIColor.white])
        let combinationText_1 = NSMutableAttributedString()
        combinationText_1.append(attributedText_1_1)
        combinationText_1.append(attributedText_1_2)
        plan_1_Text.attributedText = combinationText_1
        layer_Corner_Plan_1.fillColor = UIColor.appRed.cgColor
        
        btn_Plan_2.borderColor = UIColor.brightPurple.cgColor
        let attributedText_2_1 = NSAttributedString.init(string: (self.viewModel.products.last?.localizedPrice ?? "$0") + "\n", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Demi(size: 20),NSAttributedString.Key.foregroundColor : UIColor.brightPurple])
        let attributedText_2_2 = NSAttributedString.init(string: "for 12 months\n", attributes: [NSAttributedString.Key.font:UIFont.AvenirLTPRo_Regular(size: 18),NSAttributedString.Key.foregroundColor : UIColor.white])
        let attributedText_2_3 = NSAttributedString.init(string: "Save 38%", attributes: [NSAttributedString.Key.font:UIFont.italicSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.skyBlue])
        let combinationText_2 = NSMutableAttributedString()
        combinationText_2.append(attributedText_2_1)
        combinationText_2.append(attributedText_2_2)
        combinationText_2.append(attributedText_2_3)
        plan_2_Text.attributedText = combinationText_2
        layer_Corner_Plan_2.fillColor = UIColor.brightPurple.cgColor
    }
}

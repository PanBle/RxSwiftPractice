//
//  UseChamelonViewController.swift
//  RxSwiftPractice
//
//  Created by KM_TM on 06/09/2019.
//  Copyright © 2019 KM_TM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class UseChamelonViewController: UIViewController {

    @IBOutlet weak var circleView: UIView!
    
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        //UiView룰 원으로 만들기
        circleView.layer.backgroundColor = UIColor.green.cgColor
        circleView.layer.cornerRadius = circleView.frame.width / 2.0
        circleView.center = view.center
        
        let circleViewModel = CircleViewModel()
        //circleView의 중앙지ㄴ점을 centerObservable에 bind하기
        circleView
        .rx.observe(CGPoint.self, "center")
        .bind(to: circleViewModel.centerVariable)
        .disposed(by: disposeBag)
        
        //ViewModel의 새로운 색을 추가하기 위해 backGroundObservable을 subscribe합니다.
        circleViewModel.backgroundColorObservable
            .subscribe(onNext: {[weak self] backgroundColor in
                UIView.animate(withDuration: 0.1, animations: {
                    self?.circleView.backgroundColor = backgroundColor
                    //배경색의 반대편의 색을 구합니다
                    let viewBackgroundColor = UIColor(complementaryFlatColorOf: backgroundColor)
                    //새 배경색과 기존의 배경색이 다른지 검사합니다
                    if viewBackgroundColor != backgroundColor {
                        // 원의 배경색으로 새로운 배경색을 할당합니다
                        // 원과 배경의 색이 다르게 합니다
                        self?.view.backgroundColor = viewBackgroundColor
                    }
                })
                })
        .disposed(by: disposeBag)
        
        //gesture recognizer 추가
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circleMoved(_:)))
        circleView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func circleMoved(_ recognizer:UIPanGestureRecognizer) {
        let location = recognizer.location(in: view)
        UIView.animate(withDuration: 0.1, animations: {
            self.circleView.center = location
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  CircleviewModel.swift
//  RxSwiftPractice
//
//  Created by KM_TM on 06/09/2019.
//  Copyright © 2019 KM_TM. All rights reserved.
//

import Foundation
import ChameleonFramework
import RxSwift
import RxCocoa

class CircleViewModel {
    
    var centerVariable = Variable<CGPoint?>(.zero) //variable을 하나 추가. 추후 observed도 바뀔예정
    var backgroundColorObservable:Observable<UIColor>! //observable을 하나생성. 이건 원이 중아엥 위치할때마다 배경색이 바뀜
    
    init() {
        setup()
    }
    
    func setup() {
        backgroundColorObservable = centerVariable.asObservable()
        .map{center in
            guard let center = center else {return UIColor.flatten(.black)()}
            
            let red: CGFloat = ((center.x + center.y).truncatingRemainder(dividingBy: 255.0)) / 255.0 //빨간색을 조정, %연산자는 정수형에서만 사용이 가능하기 때문에 truncatingRemainder를 사용
            let green:CGFloat = 0.0
            let blue: CGFloat = 0.0
            
            return UIColor.flatten(UIColor(red: red, green: green, blue: blue, alpha: 1.0))()
        }
    }
}

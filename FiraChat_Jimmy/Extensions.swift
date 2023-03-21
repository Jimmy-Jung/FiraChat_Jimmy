//
//  Extensions.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/17.
//

import UIKit
import JGProgressHUD

extension UIColor {
    class var kakaoLightBrown: UIColor? {
        return UIColor(named: "kakaoLightBrown")
    }
    class var kakaoBrown: UIColor? {
        return UIColor(named: "kakaoBrown")
    }
    class var kakaoYellow: UIColor? {
        return UIColor(named: "kakaoYellow")
    }
    class var kakaoTextBrown: UIColor? {
        return UIColor(named: "kakaoTextBrown")
    }
}

extension UIView {
    //로그인 오류시 글씨 흔들기
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.08
        shake.repeatCount = 2
        shake.autoreverses = true
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))

        self.layer.add(shake, forKey: "position")
    }
}

extension UIViewController {
    func showLoader(_ show: Bool, withText text: String? = "로딩중") {
        view.endEditing(true)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = text
        
        if show {
            hud.show(in: view)
        } else {
            hud.dismiss()
        }
    }
    
    func configureNavigationBar(withTitle: String, prefersLargeTitle: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .systemPurple
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitle
        //navigationController?.title = withTitle
        navigationItem.title = withTitle
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
}

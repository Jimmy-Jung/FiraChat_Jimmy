//
//  RegistView.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/17.
//

import UIKit
import SnapKit

final class RegistView: UIView {

    private let textViewHeight: CGFloat = 48
    
    //로고 이미지
    lazy var profileImgButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
//        imageView.layer.borderWidth = 2
//        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    // "이름을 입력하세요" 안내문구
    let nameInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "이름을 입력하세요"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .kakaoLightBrown
        return label
    }()
   
    // MARK: - 이름 입력하는 텍스트 뷰
    lazy var nameTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.addSubview(nameInfoLabel)
        view.addSubview(nameTextField)
        return view
    }()

    // 회원가입 - 이름 입력 필드
    lazy var nameTextField: UITextField = {
        var tf = UITextField()
        tf.frame.size.height = 48
        tf.backgroundColor = .clear
        tf.textColor = .kakaoBrown
        tf.tintColor = .kakaoBrown
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        return tf
    }()
    
    // MARK: - 이메일 입력하는 텍스트 뷰
    lazy var emailTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.addSubview(emailInfoLabel)
        view.addSubview(emailTextField)
        return view
    }()
    
    // "이메일 또는 전화번호" 안내문구
    let emailInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일주소"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .kakaoLightBrown
        return label
    }()
    
    // 로그인 - 이메일 입력 필드
    lazy var emailTextField: UITextField = {
        var tf = UITextField()
        tf.frame.size.height = 48
        tf.backgroundColor = .clear
        tf.textColor = .kakaoBrown
        tf.tintColor = .kakaoBrown
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    // MARK: - 비밀번호 입력하는 텍스트 뷰
    lazy var passwordTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.addSubview(passwordTextField)
        view.addSubview(passwordInfoLabel)
        view.addSubview(passwordSecureButton)
        return view
    }()
    
    // 패스워드텍스트필드의 안내문구
    let passwordInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .kakaoLightBrown
        return label
    }()
    
    // 로그인 - 비밀번호 입력 필드
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.frame.size.height = 48
        tf.backgroundColor = .clear
        tf.textColor = .kakaoBrown
        tf.tintColor = .kakaoBrown
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.isSecureTextEntry = true
        tf.clearsOnBeginEditing = false
        return tf
    }()

    // 패스워드에 "표시"버튼 비밀번호 가리기 기능
    lazy var passwordSecureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("표시", for: .normal)
        button.setTitleColor(UIColor.kakaoLightBrown, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return button
    }()
    
    //회원가입 버튼
    lazy var joinButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .kakaoLightBrown
        button.layer.cornerRadius = 5
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.kakaoTextBrown, for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        return button
    }()
    // 이메일텍스트필드, 패스워드, 로그인버튼 스택뷰에 배치
    lazy var stackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [nameTextFieldView,emailTextFieldView, passwordTextFieldView, joinButton])
        stview.spacing = 18
        stview.axis = .vertical
        stview.distribution = .fillEqually
        stview.alignment = .fill
        return stview
    }()
    

    // MARK: - 이니셜라이저

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .kakaoYellow
        setup()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .kakaoYellow
        [profileImgButton,stackView].forEach { self.addSubview($0) }
    }
    
    private func setupAutoLayout() {
        nameInfoLabel.snp.makeConstraints { make in
            make.edges.equalTo(nameTextFieldView).inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        }
        nameTextField.snp.makeConstraints { make in
            make.edges.equalTo(nameTextFieldView).inset(UIEdgeInsets(top: 15, left: 8, bottom: 2, right: 8))
        }
        emailInfoLabel.snp.makeConstraints { make in
            make.edges.equalTo(emailTextFieldView).inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        }
        emailTextField.snp.makeConstraints { make in
            make.edges.equalTo(emailTextFieldView).inset(UIEdgeInsets(top: 15, left: 8, bottom: 2, right: 8))
        }
        passwordInfoLabel.snp.makeConstraints { make in
            make.edges.equalTo(passwordTextFieldView).inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        }
        passwordTextField.snp.makeConstraints { make in
            make.edges.equalTo(passwordTextFieldView).inset(UIEdgeInsets(top: 15, left: 8, bottom: 2, right: 8))
        }
        passwordSecureButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(passwordTextFieldView).inset(15)
            make.trailing.equalTo(passwordTextFieldView).inset(8)
        }
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(textViewHeight * 4 + 36)
        }
        profileImgButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(stackView.snp.top).offset(-20)
            make.height.width.equalTo(textViewHeight * 4)
        }
        profileImgButton.layer.cornerRadius = textViewHeight * 1.5
    }
}

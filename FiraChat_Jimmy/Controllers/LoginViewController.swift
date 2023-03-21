//
//  LoginViewController.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/17.
//

import UIKit
import FirebaseAuth
import SnapKit
import JGProgressHUD

final class LoginViewController: UIViewController{
    
    private let loginView = LoginView()
    let registVC = RegistrationViewController()
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        keyboardSetObserver()
        setupDelegate()
        setupAddTarget()
        autoLogin()
        setupNavigationBar()
    }
    
    private func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
     
    
    private func keyboardSetObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
    }
    
    @objc func keyboardWillShow() {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 24
        }
    }
    
    @objc func keyboardWillHide(){
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    //네비게이션바 세팅
    private func setupNavigationBar() {
        let backBarButtonItem = UIBarButtonItem(title: "로그인", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .black  // 색상 변경
            self.navigationItem.backBarButtonItem = backBarButtonItem
    }

    // 셋팅
    private func setupDelegate() {
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    
    private func setupAddTarget() {
        loginView.emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        loginView.passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        loginView.passwordSecureButton.addTarget(self, action: #selector(passwordSecureModeSetting), for: .touchUpInside)
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginView.registerButton.addTarget(self, action: #selector(registerBButtonTapped  ), for: .touchUpInside)
    }
    
    private func autoLogin() {
        loginView.emailTextField.text = "jimmy@naver.com"
        loginView.passwordTextField.text = "z123456"
        loginView.loginButton.isEnabled = true
    }
    
    // MARK: - 비밀번호 가리기 모드 켜고 끄기
    @objc private func passwordSecureModeSetting() {
        // 이미 텍스트필드에 내장되어 있는 기능
        loginView.passwordTextField.isSecureTextEntry.toggle()
    }
    
    // 로그인 버튼 누르면 동작하는 함수
    @objc func loginButtonTapped() {
        // 서버랑 통신해서, 다음 화면으로 넘어가는 내용 구현
        print("다음 화면으로 넘어가기")
        
        guard
            let email = loginView.emailTextField.text, !email.isEmpty, LogicModel.isValidEmail(testStr: email)
        else {
            loginView.emailInfoLabel.text = "이메일 양식이 올바르지 않습니다"
            loginView.emailInfoLabel.textColor = .systemRed
            loginView.emailInfoLabel.shake()
            return
        }
        guard
            let password = loginView.passwordTextField.text, !password.isEmpty,
            LogicModel.isValidPassword(password: password)
        else {
            loginView.passwordInfoLabel.text = "숫자와 영어 조합 6자리 이상 입력하세요"
            loginView.passwordInfoLabel.textColor = .systemRed
            loginView.passwordInfoLabel.shake()
            return
        }
        showLoader(true, withText: "로그인 로딩중")
        //파이어베이스 로그인
        AuthAPI.logInUser(withEmail: email, password: password) { success, message in
            
            DispatchQueue.main.async {
                self.showLoader(false)
            }
            if success {
                self.dismiss(animated: true)
            } else {
                let alertController = UIAlertController(title: "로그인 실패", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
    }
    
    // 회원가입 버튼이 눌리면 동작하는 함수
    @objc func registerBButtonTapped() {
        //만들기
        let alert = UIAlertController(title: "회원가입", message: "계정을 생성하시겠습니까?", preferredStyle: .alert)
        let success = UIAlertAction(title: "확인", style: .default) { [weak self] action in
            print("확인버튼이 눌렸습니다.")
            guard let self = self else {return}
            self.navigationController?.pushViewController(self.registVC, animated: true)
            
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { action in
            print("취소버튼이 눌렸습니다.")
        }
        
        alert.addAction(success)
        alert.addAction(cancel)
        
        // 실제 띄우기
        self.present(alert, animated: true, completion: nil)
    }
    
    // 앱의 화면을 터치하면 동작하는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
}


extension LoginViewController: UITextFieldDelegate {
    // MARK: - 텍스트필드 델리게이트
    //텍스트필드 편집 시작할때의 설정 - 문구가 위로올라가면서 크기 작아지고, 오토레이아웃 업데이트
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == loginView.emailTextField {
            loginView.emailTextFieldView.backgroundColor = #colorLiteral(red: 0.9543645978, green: 0.9543645978, blue: 0.9543645978, alpha: 1)
            loginView.emailInfoLabel.font = UIFont.systemFont(ofSize: 11)
            // 오토레이아웃 업데이트
            loginView.emailInfoLabel.snp.updateConstraints { make in
                make.edges.equalTo(loginView.emailTextFieldView).inset(UIEdgeInsets(top: 0, left: 8, bottom: 13, right: 8))
            }
        }
        
        if textField == loginView.passwordTextField {
            loginView.passwordTextFieldView.backgroundColor = #colorLiteral(red: 0.9543645978, green: 0.9543645978, blue: 0.9543645978, alpha: 1)
            loginView.passwordInfoLabel.font = UIFont.systemFont(ofSize: 11)
            // 오토레이아웃 업데이트
            loginView.passwordInfoLabel.snp.updateConstraints { make in
                make.edges.equalTo(loginView.passwordTextFieldView).inset(UIEdgeInsets(top: 0, left: 8, bottom: 13, right: 8))
            }
        }
        
        // 실제 레이아웃 변경은 애니메이션으로 줄꺼야
        UIView.animate(withDuration: 0.3) {
            self.loginView.stackView.layoutIfNeeded()
        }
    }
    
    
    // 텍스트필드 편집 종료되면 백그라운드 색 변경 (글자가 한개도 입력 안되었을때는 되돌리기)
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == loginView.emailTextField {
            loginView.emailTextFieldView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            // 빈칸이면 원래로 되돌리기
            if loginView.emailTextField.text == "" {
                loginView.emailInfoLabel.font = UIFont.systemFont(ofSize: 18)
                
                loginView.emailInfoLabel.snp.updateConstraints { make in
                    make.edges.equalTo(loginView.emailTextFieldView).inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
                }
            }
        }
        if textField == loginView.passwordTextField {
            loginView.passwordTextFieldView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            // 빈칸이면 원래로 되돌리기
            if loginView.passwordTextField.text == "" {
                loginView.passwordInfoLabel.font = UIFont.systemFont(ofSize: 18)
                
                loginView.passwordInfoLabel.snp.updateConstraints { make in
                    make.edges.equalTo(loginView.passwordTextFieldView).inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
                }
            }
        }
        // 실제 레이아웃 변경은 애니메이션으로 줄꺼야
        UIView.animate(withDuration: 0.3) {
            self.loginView.emailInfoLabel.layoutIfNeeded()
            self.loginView.passwordInfoLabel.layoutIfNeeded()
        }
    }
    
    // MARK: - 로그인 텍스트필드 검사
    @objc private func textFieldEditingChanged(_ textField: UITextField) {

        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                loginView.loginButton.backgroundColor = .kakaoLightBrown
                loginView.loginButton.isEnabled = false
                return
            }
        }
        //이메일과 비밀번호 텍스트필드 두가지 다 채워져있을 때 로그인 버튼 활성화
        guard
            let email = loginView.emailTextField.text, !email.isEmpty,
            let password = loginView.passwordTextField.text, !password.isEmpty
        else {
            loginView.loginButton.backgroundColor = .kakaoLightBrown
            loginView.loginButton.isEnabled = false
            return
        }
        //기본상태
        loginView.emailInfoLabel.text = "이메일주소"
        loginView.passwordInfoLabel.text = "비밀번호"
        loginView.loginButton.backgroundColor = .kakaoBrown
        loginView.loginButton.isEnabled = true
        
        //정규식 합격하면 플레이스홀더 초록색
        if textField == loginView.emailTextField {
            if LogicModel.isValidEmail(testStr: email) {
                loginView.emailInfoLabel.textColor = .systemGreen
                return
            } else {
                loginView.emailInfoLabel.textColor = .kakaoLightBrown
                return
            }
        } else {
            if LogicModel.isValidPassword(password: password) {
                loginView.passwordInfoLabel.textColor = .systemGreen
                return
            } else {
                loginView.passwordInfoLabel.textColor = .kakaoLightBrown
                return
            }
        }
        
    }
    
    
    // 엔터 누르면 일단 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}





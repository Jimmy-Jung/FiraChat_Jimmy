//
//  RegistViewController.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/17.
//

import UIKit
import SnapKit
import FirebaseAuth
import JGProgressHUD

class RegistrationViewController: UIViewController {

    let registView = RegistView()
    private let spinner = JGProgressHUD(style: .dark)
    override func loadView() {
        view = registView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupAddTarget()
    }
    
  
    
    // 셋팅
    private func setupDelegate() {
        registView.nameTextField.delegate = self
        registView.emailTextField.delegate = self
        registView.passwordTextField.delegate = self
    }
    
    private func setupAddTarget() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        registView.profileImgButton.addGestureRecognizer(gesture)
        registView.profileImgButton.isUserInteractionEnabled = true
        registView.nameTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        registView.emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        registView.passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        registView.passwordSecureButton.addTarget(self, action: #selector(passwordSecureModeSetting), for: .touchUpInside)
        registView.joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
        
    }
    
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    // MARK: - 비밀번호 가리기 모드 켜고 끄기
    @objc private func passwordSecureModeSetting() {
        // 이미 텍스트필드에 내장되어 있는 기능
        registView.passwordTextField.isSecureTextEntry.toggle()
    }
    
    @objc func joinButtonTapped() {
        // 서버랑 통신해서, 다음 화면으로 넘어가는 내용 구현
        print("로그인 화면으로 넘어가기")
        guard
            let name = registView.nameTextField.text, !name.isEmpty, LogicModel.isValidName(name: name)
        else {
            registView.nameInfoLabel.textColor = .systemRed
            registView.nameInfoLabel.text = "영어 혹은 한글만 입력하세요"
            registView.nameInfoLabel.shake()
            return
        }
        guard
            let email = registView.emailTextField.text, !email.isEmpty, LogicModel.isValidEmail(testStr: email)
        else {
            registView.emailInfoLabel.textColor = .systemRed
            registView.emailInfoLabel.text = "이메일 양식이 틀렸습니다"
            registView.emailInfoLabel.shake()
            return
        }
        guard
            let password = registView.passwordTextField.text, !password.isEmpty,
            LogicModel.isValidPassword(password: password)
        else {
            registView.passwordInfoLabel.textColor = .systemRed
            registView.passwordInfoLabel.text = "영문과 숫자 포함 6자리 이상 입력하세요"
            registView.passwordInfoLabel.shake()
            return
        }
        spinner.show(in: view)
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else {return}
            
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            
            if let e = error {
                print(e)
            } else {
                DataManager.loginCheck = true
                self.dismiss(animated: true)
                return
            }
        }
        
    }

}

extension RegistrationViewController: UITextFieldDelegate {
    // MARK: - 텍스트필드 델리게이트
    //텍스트필드 편집 시작할때의 설정 - 문구가 위로올라가면서 크기 작아지고, 오토레이아웃 업데이트
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        if textField == registView.nameTextField {
            registView.nameTextFieldView.backgroundColor = #colorLiteral(red: 0.9543645978, green: 0.9543645978, blue: 0.9543645978, alpha: 1)
            registView.nameInfoLabel.font = UIFont.systemFont(ofSize: 11)
            // 오토레이아웃 업데이트
            registView.nameInfoLabel.snp.updateConstraints { make in
                make.edges.equalTo(registView.nameTextFieldView).inset(UIEdgeInsets(top: 0, left: 8, bottom: 13, right: 8))
            }
        }
        if textField == registView.emailTextField {
            registView.emailTextFieldView.backgroundColor = #colorLiteral(red: 0.9543645978, green: 0.9543645978, blue: 0.9543645978, alpha: 1)
            registView.emailInfoLabel.font = UIFont.systemFont(ofSize: 11)
            // 오토레이아웃 업데이트
            registView.emailInfoLabel.snp.updateConstraints { make in
                make.edges.equalTo(registView.emailTextFieldView).inset(UIEdgeInsets(top: 0, left: 8, bottom: 13, right: 8))
            }
        }
        
        if textField == registView.passwordTextField {
            registView.passwordTextFieldView.backgroundColor = #colorLiteral(red: 0.9543645978, green: 0.9543645978, blue: 0.9543645978, alpha: 1)
            registView.passwordInfoLabel.font = UIFont.systemFont(ofSize: 11)
            // 오토레이아웃 업데이트
            registView.passwordInfoLabel.snp.updateConstraints { make in
                make.edges.equalTo(registView.passwordTextFieldView).inset(UIEdgeInsets(top: 0, left: 8, bottom: 13, right: 8))
            }
        }
        
        // 실제 레이아웃 변경은 애니메이션으로 줄꺼야
        UIView.animate(withDuration: 0.3) {
            self.registView.stackView.layoutIfNeeded()
        }
    }
    
    
    // 텍스트필드 편집 종료되면 백그라운드 색 변경 (글자가 한개도 입력 안되었을때는 되돌리기)
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == registView.nameTextField {
            registView.nameTextFieldView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            // 빈칸이면 원래로 되돌리기
            if registView.nameTextField.text == "" {
                registView.nameInfoLabel.font = UIFont.systemFont(ofSize: 18)
                
                registView.nameInfoLabel.snp.updateConstraints { make in
                    make.edges.equalTo(registView.nameTextFieldView).inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
                }
            }
        }
        if textField == registView.emailTextField {
            registView.emailTextFieldView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            // 빈칸이면 원래로 되돌리기
            if registView.emailTextField.text == "" {
                registView.emailInfoLabel.font = UIFont.systemFont(ofSize: 18)
                
                registView.emailInfoLabel.snp.updateConstraints { make in
                    make.edges.equalTo(registView.emailTextFieldView).inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
                }
            }
        }
        if textField == registView.passwordTextField {
            registView.passwordTextFieldView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            // 빈칸이면 원래로 되돌리기
            if registView.passwordTextField.text == "" {
                registView.passwordInfoLabel.font = UIFont.systemFont(ofSize: 18)
                
                registView.passwordInfoLabel.snp.updateConstraints { make in
                    make.edges.equalTo(registView.passwordTextFieldView).inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
                }
            }
        }
        // 실제 레이아웃 변경은 애니메이션으로 줄꺼야
        UIView.animate(withDuration: 0.3) {
            self.registView.stackView.layoutIfNeeded()
//            self.registView.emailInfoLabel.layoutIfNeeded()
//            self.registView.passwordInfoLabel.layoutIfNeeded()
        }
    }
    
    // MARK: - 로그인 텍스트필드 검사
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                registView.joinButton.backgroundColor = .kakaoLightBrown
                registView.joinButton.isEnabled = false
                return
            }
        }
        
        //정규식 합격하면 플레이스홀더 초록색
        if textField == registView.nameTextField {
            guard let name = registView.nameTextField.text, !name.isEmpty, LogicModel.isValidName(name: name)
            else {
                registView.nameInfoLabel.textColor = .kakaoLightBrown
                return
            }
            registView.nameInfoLabel.textColor = .systemGreen
        }
        else if textField == registView.emailTextField {
            guard let email = registView.emailTextField.text, !email.isEmpty, LogicModel.isValidEmail(testStr: email)
            else {
                registView.emailInfoLabel.textColor = .kakaoLightBrown
                return
            }
            registView.emailInfoLabel.textColor = .systemGreen
        }
        else if textField == registView.passwordTextField {
            guard let password = registView.passwordTextField.text, !password.isEmpty, LogicModel.isValidPassword(password: password)
            else {
                registView.passwordInfoLabel.textColor = .kakaoLightBrown
                return
            }
            registView.passwordInfoLabel.textColor = .systemGreen
        }
        
        //이메일과 비밀번호 텍스트필드 두가지 다 채워져있을 때 로그인 버튼 활성화
        guard
            let name = registView.nameTextField.text, !name.isEmpty,
            let email = registView.emailTextField.text, !email.isEmpty,
            let password = registView.passwordTextField.text, !password.isEmpty
        else {
            registView.joinButton.backgroundColor = .kakaoLightBrown
            registView.joinButton.isEnabled = false
            return
        }
        //기본상태
        registView.nameInfoLabel.text = "이름"
        registView.emailInfoLabel.text = "이메일주소"
        registView.passwordInfoLabel.text = "비밀번호"
        registView.joinButton.backgroundColor = .kakaoBrown
        registView.joinButton.isEnabled = true
        
    }
    
    
    // 엔터 누르면 일단 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "프로필 사진",
                                            message: "프로필 사진을 고르시겠습니까?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "취소",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "사진 촬영",
                                            style: .default,
                                            handler: { [weak self] _ in

                                                self?.presentCamera()

        }))
        actionSheet.addAction(UIAlertAction(title: "사진 고르기",
                                            style: .default,
                                            handler: { [weak self] _ in

                                                self?.presentPhotoPicker()

        }))

        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }

        registView.profileImgButton.image = selectedImage
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

//extension RegistrationViewController: UINavigationBarDelegate {
//    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
//            item.title = "돌아가기"
//            return true
//        }
//
//}

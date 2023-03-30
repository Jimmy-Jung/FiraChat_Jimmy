//
//  CustomInputAccessoryView.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/22.
//

import UIKit
import SnapKit

protocol CustomInputAccessoryViewDelegate: AnyObject {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String)
}

final class CustomInputAccessoryView: UIView {

    // MARK: - 프로퍼티
    weak var delegate: CustomInputAccessoryViewDelegate?
    
    private let messageInputTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.textContainer.maximumNumberOfLines = 3
        return tv
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "메세지를 입력하세요"
        label.textColor = .lightGray
        return label
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return button
    }()
    
    // MARK: - 라이프사이클
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8)
        sendButton.setDimensions(height: 50, width: 50)
//        sendButton.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(4)
//            make.trailing.equalToSuperview().inset(8)
//            make.height.width.equalTo(50)
//        }
        
        addSubview(messageInputTextView)
        messageInputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 12, paddingLeft: 4, paddingBottom: 8, paddingRight: 8)
        
        
//        messageInputTextView.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(12)
//            make.leading.equalToSuperview().inset(8)
//            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
//            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(8)
//           // make.height.greaterThanOrEqualTo(18)
//        }
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(left: messageInputTextView.leftAnchor, paddingLeft: 4)
        placeholderLabel.centerY(inView: messageInputTextView)
//        placeholderLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(messageInputTextView)
//            make.left.equalTo(messageInputTextView).inset(8)
//        }
        
       sendButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    //뷰의 내재적인(content) 크기를 0으로 설정합니다
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 메서드

    @objc func handleTextInputChange() {
        placeholderLabel.isHidden = !self.messageInputTextView.text.isEmpty
    }
    @objc func handleSendMessage() {
        guard let message = messageInputTextView.text else {return}
        delegate?.inputView(self, wantsToSend: message)
    }

    func clearMessageText() {
        messageInputTextView.text = nil
        placeholderLabel.isHidden = false
    }

}

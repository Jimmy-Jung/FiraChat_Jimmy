//
//  MessageCell.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/22.
//

import UIKit

class MessageCell: UICollectionViewCell {
    // MARK: - 프로퍼티
    
    var message: Message? {
        didSet { configure() }
    }
    
    private let  profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let textView: UITextView = {
       let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.textColor = .white
        return tv
    }()
    
    private let bubbleContainer: UIView = {
       let view = UIView()
        view.backgroundColor = .systemPurple
        return view
    }()
    
    
    // MARK: - 라이프사이클
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(9)
            make.left.equalToSuperview().inset(8)
            make.width.height.equalTo(32)
        }
        
        
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        
        bubbleContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(profileImageView.snp.right).offset(12)
            make.width.lessThanOrEqualTo(250)
        }
        
        
        bubbleContainer.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalTo(bubbleContainer).inset(UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
        }
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func configure() {
        guard let message = message else {return}
        let viewModel = MessageViewModel(message: message)
        
        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        textView.textColor = viewModel.messageTextColor
        textView.text = message.text
        
        bubbleContainer.snp.removeConstraints()
        
        if message.isFromCurrentUser {
            self.profileImageView.isHidden = true
            bubbleContainer.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.right.equalToSuperview().inset(12)
                make.width.lessThanOrEqualTo(250)
            }
        } else {
            self.profileImageView.isHidden = false
            bubbleContainer.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(profileImageView.snp.right).offset(12)
                make.width.lessThanOrEqualTo(250)
            }
        }
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }

}

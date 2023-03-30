//
//  ConversationCell.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/25.
//

import UIKit
import SDWebImage
import FirebaseAuth

class ConversationCell: UITableViewCell {
    
    // MARK: - 프로퍼티
    
    var conversation: Conversation? {
        didSet { configure() }
    }
    
    private let defaultConstraint: CGFloat = 56
    
    private let profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "person.crop.circle")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.text = "2h"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "이름"
        return label
    }()
    
    private let messageTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - 라이프사이클
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 12)
        profileImageView.setDimensions(height: 50, width: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerY(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, messageTextLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: profileImageView)
        stack.anchor(left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 16)
        
        addSubview(timestampLabel)
        timestampLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 20, paddingRight: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 메서드
    
    private func configure() {
        guard let conversation = conversation else {return}
        let viewMedel = ConversationViewModel(conversation: conversation)
        usernameLabel.text = {
            if conversation.user.uid == Auth.auth().currentUser?.uid {
                return "나와의 대화"
            } else {
                return conversation.user.name
            }
        }()
        messageTextLabel.text = conversation.message.text
        timestampLabel.text = viewMedel.tilestamp
        profileImageView.sd_setImage(with: viewMedel.profileImageUrl)
    }
    



}

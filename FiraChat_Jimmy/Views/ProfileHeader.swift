//
//  ProfileHeader.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/27.
//

import UIKit

protocol ProfileHeaderDelegate: AnyObject {
    func dismissController()
}

final class ProfileHeader: UIView {

    // MARK: - Properties
    
    var user: User? {
        didSet {
            populateUserData()
        }
    }
    weak var delegate: ProfileHeaderDelegate?
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        
        button.tintColor = .white
        button.imageView?.setDimensions(height: 22, width: 22)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4.0
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "지미풀네임"
        return label
    }()
    
    private let userEmailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "상태메세지"
        return label
    }()
        
        
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .kakaoLightBrown
        configureUI()
        dismissButton.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
    fatalError("init (coder:) has not been implemented" )
    }
        
    // MARK: - Sellector
    
    @objc func handleDismissal() {
        delegate?.dismissController()
    }

    // MARK: - Helpers

    func populateUserData() {
        guard let user = user else { return }
        fullnameLabel.text = user.name
        userEmailLabel.text = user.email
        
        guard let url = URL(string: user.profileImageUrl) else {return}
        profileImageView.sd_setImage(with: url)
    }
    
    func configureUI() {
        configureGradientLayer()
        profileImageView.setDimensions(height: 200, width: 200)
        profileImageView.layer.cornerRadius = 200 / 2
        addSubview(profileImageView)
        profileImageView.centerX(inView: self)
        profileImageView.anchor(top: topAnchor, paddingTop: 96)
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, userEmailLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: profileImageView.bottomAnchor, paddingTop: 16)
        
        addSubview(dismissButton)
        dismissButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12)
        dismissButton.setDimensions(height: 48, width: 48)
    }
    
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        gradient.locations = [0, 1]
        layer.addSublayer(gradient)
        gradient.frame = bounds
        
    }
                          
                          
}

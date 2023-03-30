//
//  UserCell.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/21.
//

import UIKit
import SnapKit
import SDWebImage

class UserCell: UITableViewCell {
    var user: User? {
        didSet { configureUser() }
    }
    
    // MARK: - 프로퍼티
    private let defaultConstraint: CGFloat = 56
    
    private let  profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(systemName: "person.crop.circle")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "이름"
        return label
    }()
    
    private let situationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "상태메세지"
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        [usernameLabel, situationLabel].forEach {sv.addArrangedSubview($0)}
        sv.axis = .vertical
        sv.spacing = 6
        return sv
    }()
    
    // MARK: - 라이프사이클

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    // MARK: - 메서드
    
    private func configureUI() {
        [profileImageView, stackView].forEach {self.addSubview($0)}
        setupAutoLayout()
    }
    
    private func configureUser() {
        guard let user = user else {return}
        usernameLabel.text = user.name
        guard let url = URL(string: user.profileImageUrl) else {return}
        profileImageView.sd_setImage(with: url)
    }
    
    private func setupAutoLayout() {
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
            make.height.width.equalTo(defaultConstraint)
        }
        profileImageView.layer.cornerRadius = defaultConstraint / 3 
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
    }

    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

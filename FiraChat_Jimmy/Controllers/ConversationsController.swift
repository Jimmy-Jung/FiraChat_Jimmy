//
//  ConversationsController.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/17.
//

import UIKit
import FirebaseAuth

private let reuseIdentifier = "ConversationCell"

final class ConversationsController: UIViewController {
    
    // MARK: - 프로퍼티

    private let tableView = UITableView()
    private var conversations = [Conversation]()
    
    private let newMassageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemPurple
        button.tintColor = .white
        button.imageView?.snp.makeConstraints { make in
            make.height.width.equalTo(26)
        }
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 생명주기

    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
        configureUI()
        fetchConversation()

       
    }
    
    // MARK: - 메서드

    private func fetchConversation() {
        print("대화불러오기 메서드 실행")
        Service.fetchConversations { [weak self] conversations in
            guard let self = self else {return}
            self.conversations = conversations
            print("대화: \(self.conversations)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
           
        }
    }
    
    private func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            presentLoginScreen()
        } else {
            print("DEBUG: UserID is \(String(describing: Auth.auth().currentUser?.uid))")
        }
    }
    
    private func presentLoginScreen() {
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false, completion: nil)
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
            presentLoginScreen()
        } catch {
            print("DEBUG: signing out")
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar(withTitle: "Messages", prefersLargeTitle: true)
        configureTableView()
    
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        
        view.addSubview(newMassageButton)
        newMassageButton.layer.cornerRadius = 56 / 2
        newMassageButton.snp.makeConstraints { make in
            make.width.height.equalTo(56)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.trailing.equalToSuperview().inset(24)
        }
        
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    // MARK: - 셀렉터

    @objc func showProfile() {
        let alertController = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self]_ in
            self?.logOut()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func showNewMessage() {
        let controller = NewMessageController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
//        navigationController?.pushViewController(controller, animated: true)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    // MARK: - 익스텐션

}
extension ConversationsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = conversations[indexPath.row].message.text
        
        return cell
    }
    
    
}

extension ConversationsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

// MARK: - NewMessageControllerDelegate
extension ConversationsController: NemessageControllerDelegate {
    func controller(_ controller: NewMessageController, wnatsToStartChatWith user: User) {
        controller.dismiss(animated: true)
        let chat = ChatController(user: user)
        navigationController?.pushViewController(chat, animated: true)
    }
}


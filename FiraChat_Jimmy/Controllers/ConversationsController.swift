//
//  ConversationsController.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/17.
//

import UIKit
import SnapKit
import FirebaseAuth

private let reuseIdentifier = "ConversationCell"

final class ConversationsController: UIViewController {
    
    
    // MARK: - 프로퍼티

    private let tableView = UITableView()
    private var conversations = [Conversation]()
    private var conversationDictionary = [String: Conversation]()
    
    private let newMassageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemPurple
        button.tintColor = .white
        button.imageView?.snp.makeConstraints { make in
            make.height.width.equalTo(26)
        }
        button.layer.masksToBounds = true
        
        return button
    }()
    
    // MARK: - 생명주기

    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
        configureUI()
        fetchConversation()
        newMassageButton.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
    }
    
    // MARK: - 메서드

    private func fetchConversation() {
        print("패치대화 메서드 실행")
        showLoader(true)
        Service.fetchConversations { [weak self] conversations, error in
            guard let self = self else { return }
            print("패치대화 서버 연동중")
            if let _ = error {
                self.showLoader(false)
                return
                
            }
            self.showLoader(false)
            guard let cv = conversations else {return}
            cv.forEach { conversation in
                let message = conversation.message
                self.conversationDictionary[message.toID] = conversation
            }
            self.conversations = Array(self.conversationDictionary.values)
            self.tableView.reloadData()
        }
    }
    
    private func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            presentLoginScreen()
        } else {
            print("DEBUG: UserID is \(String(describing: Auth.auth().currentUser?.uid))")
        }
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
            presentLoginScreen()
        } catch {
            print("DEBUG: signing out")
        }
    }
    
    private func presentLoginScreen() {
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false, completion: nil)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
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
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    private func showChatcontroller(forUser user: User) {
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    // MARK: - 셀렉터

    @objc func showProfile() {
        let controller = ProfileController(style: .insetGrouped)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        cell.conversation = conversations[indexPath.row]
        
        
        return cell
    }
    
    
}

extension ConversationsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = conversations[indexPath.row].user
        showChatcontroller(forUser: user)
    }
}

// MARK: - NewMessageControllerDelegate
extension ConversationsController: NemessageControllerDelegate {
    func controller(_ controller: NewMessageController, wnatsToStartChatWith user: User) {
        dismiss(animated: true)
        showChatcontroller(forUser: user)
    }
}

extension ConversationsController: ProfileControllerDelegate {
    func handleLogout() {
        logOut()
    }
}

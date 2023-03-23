//
//  NewMessageController.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/20.
//

import UIKit

private let reuseIdentifier = "UserReuseCell"

protocol NemessageControllerDelegate: class {
    func controller(_ controller: NewMessageController, wnatsToStartChatWith user: User)
}

final class NewMessageController: UITableViewController {
    // MARK: - 프로퍼티
    var users = [User]()
    weak var delegate: NemessageControllerDelegate?
    // MARK: - 라이프사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUsers()
    }
    // MARK: - 셀렉터
    @objc func handleDismissal() {
        dismiss(animated: true)
    }
    
    // MARK: - API
    private func fetchUsers() {
        Service.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }

    
    // MARK: - 메서드
    
    
    private func configureUI() {
        configureNavigationBar(withTitle: "New Message", prefersLargeTitle: false)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismissal))
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 88
    }
}

    // MARK: - Table DataSource
extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        
        return cell
    }
}

extension NewMessageController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.controller(self, wnatsToStartChatWith: users[indexPath.row])
    }
}

//
//  NewMessageController.swift
//  FiraChat_Jimmy
//
//  Created by 정준영 on 2023/03/20.
//

import UIKit

private let reuseIdentifier = "UserReuseCell"

protocol NemessageControllerDelegate: AnyObject {
    func controller(_ controller: NewMessageController, wnatsToStartChatWith user: User)
}

final class NewMessageController: UITableViewController {
    // MARK: - 프로퍼티
    private var users = [User]()
    private var filteredUsers = [User]()
    weak var delegate: NemessageControllerDelegate?
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    // MARK: - 라이프사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureSearchController()
        fetchUsers()
    }
    // MARK: - 셀렉터
    @objc func handleDismissal() {
        dismiss(animated: true)
    }
    
    // MARK: - API
    private func fetchUsers() {
        showLoader(true)
        Service.fetchUsers { [weak self] users in
            self?.showLoader(false)
            self?.users = users
            self?.tableView.reloadData()
        }
    }

    
    // MARK: - 메서드
    
    
    private func configureUI() {
        configureNavigationBar(withTitle: "New Message", prefersLargeTitles: false)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismissal))
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 88
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "사용자 찾기"
        definesPresentationContext = false
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .systemPurple
            textField.backgroundColor = .white
        }
    }
}



    // MARK: - Table DataSource
extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        return cell
    }
}

extension NewMessageController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        delegate?.controller(self, wnatsToStartChatWith: user)
    }
}

extension NewMessageController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        
        filteredUsers = users.filter({ user in
            return user.name.contains(searchText)
        })
        self.tableView.reloadData()
        
    }
}

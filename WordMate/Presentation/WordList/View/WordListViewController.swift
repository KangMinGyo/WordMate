//
//  WordListViewController.swift
//  WordMate
//
//  Created by KangMingyo on 11/14/24.
//

import UIKit

class WordListViewController: UIViewController {

   var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        tableView.dataSource = self
//        tableView.delegate = self
        tableView.register(WordCell.self, forCellReuseIdentifier: "WordCell")
        view.addSubview(tableView)
    }

}

extension WordListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath) as! WordCell
        return cell
    }
    
}


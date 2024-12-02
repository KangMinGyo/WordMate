//
//  GroupSelectionViewController.swift
//  WordMate
//
//  Created by KangMingyo on 12/2/24.
//

import UIKit

class GroupSelectionViewController: UIViewController {

    // MARK: - Properties
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(GroupSelectionCell.self, forCellReuseIdentifier: "GroupSelectionCell")
    }
}

extension GroupSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupSelectionCell", for: indexPath) as! GroupSelectionCell
        
        return UITableViewCell()
    }
 
}

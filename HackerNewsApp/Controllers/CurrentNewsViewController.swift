//
//  CurrentViewController.swift
//  HackerNewsApp
//
//  Created by Vidhyadharan Mohanram on 23/09/17.
//  Copyright © 2017 Vidhyadharan. All rights reserved.
//

import UIKit

class CurrentNewsViewController: BaseViewController {

    @IBOutlet fileprivate var titleLabel: UILabel!
    @IBOutlet fileprivate var lastUpdatedLabel: UILabel!

    @IBOutlet fileprivate var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }

    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        let orangeColor = #colorLiteral(red: 0.9814164042, green: 0.3980008066, blue: 0.0119693717, alpha: 1)
        control.tintColor = orangeColor
        control.attributedTitle = NSAttributedString(string: "Pull to refresh",
                                                     attributes: [NSAttributedStringKey.foregroundColor: orangeColor])
        return control
    }()

    fileprivate var hackerNewsStories: HackerNewsStories!

    fileprivate var stories: [ItemStruct] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }

        refreshControl.addTarget(self, action: #selector(CurrentNewsViewController.refreshNews), for: .valueChanged)

        hackerNewsStories = HackerNewsStories(delegate: self)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc private func refreshNews() {
        hackerNewsStories.retrieveStories()
    }

}

extension CurrentNewsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "News Cell", for: indexPath) as! NewsTableViewCell
        cell.itemStruct = stories[indexPath.row]
        return cell
    }
}

extension CurrentNewsViewController: FirebaseUpdaterDelegate {
    func update(newStories: [ItemStruct]?) {
        refreshControl.endRefreshing()

        guard let items = newStories else { return }

        self.stories.insert(contentsOf: items, at: 0)

        tableView.beginUpdates()
        var indexPaths = [IndexPath]()
        for i in 0 ..< items.count {
            let indexPath = IndexPath(row: i, section: 0)
            indexPaths.append(indexPath)
        }
        tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        tableView.endUpdates()
    }
}


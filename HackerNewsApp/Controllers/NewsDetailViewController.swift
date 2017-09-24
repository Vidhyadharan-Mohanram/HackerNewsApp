//
//  NewsDetailViewController.swift
//  HackerNewsApp
//
//  Created by Vidhyadharan Mohanram on 24/09/17.
//  Copyright © 2017 Vidhyadharan. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController {

    @IBOutlet fileprivate var titleLabel: UILabel!
    @IBOutlet fileprivate var urlLabel: UILabel!
    @IBOutlet fileprivate var timeAndPosterNameLabel: UILabel!

    @IBOutlet fileprivate var commentsButton: UIButton! {
        didSet {
            commentsButton.isSelected = true
        }
    }
    
    @IBOutlet fileprivate var articleButton: UIButton!

    @IBOutlet fileprivate var contentScrollView: UIScrollView!
    @IBOutlet fileprivate var commentsTableView: UITableView! {
        didSet {
            commentsTableView.tableFooterView = UIView()
        }
    }
    
    @IBOutlet fileprivate var articleWebView: WKWebView!

    internal var story: ItemStruct!

    fileprivate var hackerNewsStoryComments: HackerNewsStoryComments!

    fileprivate var comments: [CommentStruct] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction private func close() {
        navigationController?.popViewController(animated: true)
    }

    internal func updateUI() {
        guard let item = story, titleLabel != nil else { return }

        hackerNewsStoryComments = HackerNewsStoryComments(commentIds: item.kids, delegate: self)
        titleLabel.text = item.title

        if let urlVal = item.url {
            urlLabel.text = urlVal
            let url = URL(string: urlVal)!
            let urlRequest = URLRequest(url: url)
            articleWebView.load(urlRequest)
        } else {
            urlLabel.text = ""
            articleButton.removeFromSuperview()
        }

        if let time = item.time, let by = item.by {
            let date = Date(timeIntervalSince1970: TimeInterval(time))
            let dateString = date.customDateString()
            timeAndPosterNameLabel.text = "\(dateString) • \(by)"
        }

        commentsButton.setTitle("\(item.descendants ?? 0) COMMENTS", for: .normal)
    }

    @IBAction fileprivate func showComments(sender: UIButton) {
        guard articleButton.isSelected else { return }
        sender.isSelected = true
        articleButton.isSelected = false

        let rect = CGRect(x: 0, y: 0, width: contentScrollView.frame.width, height: contentScrollView.frame.height)
        contentScrollView.scrollRectToVisible(rect, animated: true)
    }

    @IBAction fileprivate func showArticle(sender: UIButton) {
        guard commentsButton.isSelected else { return }
        sender.isSelected = true
        commentsButton.isSelected = false

        let rect = CGRect(x: contentScrollView.frame.width, y: 0, width: contentScrollView.frame.width, height: contentScrollView.frame.height)
        contentScrollView.scrollRectToVisible(rect, animated: true)
    }

}

extension NewsDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Comments Cell", for: indexPath) as! CommentsTableViewCell
        cell.itemStruct = comments[indexPath.row]
        return cell
    }
}

extension NewsDetailViewController: FirebaseUpdaterCommentsDelegate {
    func update(newComments: [CommentStruct]?) {
        guard let items = newComments else { return }

        self.comments.insert(contentsOf: items, at: 0)

        commentsTableView.beginUpdates()
        var indexPaths = [IndexPath]()
        for i in 0 ..< items.count {
            let indexPath = IndexPath(row: i, section: 0)
            indexPaths.append(indexPath)
        }
        commentsTableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        commentsTableView.endUpdates()
    }
}

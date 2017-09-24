//
//  CommentsTableViewCell.swift
//  HackerNewsApp
//
//  Created by Vidhyadharan Mohanram on 24/09/17.
//  Copyright © 2017 Vidhyadharan. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet fileprivate var timeAndPosterNameLabel: UILabel!
    @IBOutlet fileprivate var commentTextLabel: UILabel!

    internal var itemStruct: CommentStruct! {
        didSet {
            configureCell()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    internal func configureCell() {
        guard let item = itemStruct else { return }
        if let time = item.time, let by = item.by {
            let date = Date(timeIntervalSince1970: TimeInterval(time))
            let dateString = date.customDateAndTimeString()
            timeAndPosterNameLabel.text = "\(dateString) • \(by)"
        }

        commentTextLabel.attributedText = item.text?.html2AttributedString

    }

}

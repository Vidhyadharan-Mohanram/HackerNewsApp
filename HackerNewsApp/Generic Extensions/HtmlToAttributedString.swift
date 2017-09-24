//
//  HtmlToAttributedString.swift
//  HackerNewsApp
//
//  Created by Vidhyadharan Mohanram on 24/09/17.
//  Copyright © 2017 Vidhyadharan. All rights reserved.
//

import UIKit

extension String {
    internal var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html,
                                                                      .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
    internal var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

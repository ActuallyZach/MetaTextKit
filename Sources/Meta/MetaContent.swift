//
//  MetaContent.swift
//  
//
//  Created by Cirno MainasuK on 2021-6-25.
//

import UIKit

public protocol MetaContent {
    var string: String { get }
    var entities: [Meta.Entity] { get }

    func metaAttachment(for entity: Meta.Entity) -> MetaAttachment?
}

extension MetaContent {
    public func attributedString(accentColor: UIColor) -> AttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        
        // meta
        let stringRange = NSRange(location: 0, length: attributedString.length)
        for entity in entities {
            let range = NSIntersectionRange(stringRange, entity.range)
            switch entity.meta {
            case .mention(_, _, let userInfo):
                if let href = userInfo?["href"] as? String {
                    attributedString.addAttribute(.link, value: href, range: range)
                    attributedString.addAttribute(.foregroundColor, value: accentColor, range: range)
                } else {
                    attributedString.addAttribute(.link, value: entity.primaryText, range: range)
                    attributedString.addAttribute(.foregroundColor, value: accentColor, range: range)
                }
            default:
                attributedString.addAttribute(.link, value: entity.primaryText, range: range)
                attributedString.addAttribute(.foregroundColor, value: accentColor, range: range)
            }
        }

        return AttributedString(attributedString)
    }
}

//
//  ScrollViewProxy+ScrollToTop.swift
//  score-ios
//

import SwiftUI

extension ScrollViewProxy {
    func scrollToTopWithoutAnimation(id: some Hashable) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            scrollTo(id, anchor: .top)
        }
    }
}

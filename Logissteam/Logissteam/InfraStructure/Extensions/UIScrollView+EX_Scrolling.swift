//
//  UIScrollView+EX_Scrolling.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 08/09/2024.
//

import Foundation

import Combine
import UIKit

class ScrollPublisher: NSObject, UICollectionViewDelegate {
    private let subject = PassthroughSubject<UIScrollView, Never>()
    
    var publisher: AnyPublisher<UIScrollView, Never> {
        subject.eraseToAnyPublisher()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        subject.send(scrollView)
    }
}

extension UICollectionView {
    func isNearBottomEdge(offset: CGFloat = 100.0) -> Bool {
        let contentHeight = contentSize.height
        let contentOffsetY = contentOffset.y
        let frameHeight = bounds.size.height
        return contentHeight - contentOffsetY - frameHeight <= offset
    }
}


//private let scrollPublisher = ScrollPublisher()
//override func viewDidLoad() {
//    super.viewDidLoad()
//
//    categoriesCollectionView.delegate = scrollPublisher
//}

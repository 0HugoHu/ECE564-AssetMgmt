//
//  SFileScrollDelegate.swift
//  SwiftyFileBrowser
//
//  Created by walker on 2022/4/21.
//

import Foundation
import UIKit

@objc public protocol SFileBrowserScrollDelegate {
    
    @objc optional func scrollViewDidScroll(_ scrollView: UIScrollView) // any offset changes

    @objc optional func scrollViewDidZoom(_ scrollView: UIScrollView) // any zoom scale changes

    // called on start of dragging (may require some time and or distance to move)
    @objc optional func scrollViewWillBeginDragging(_ scrollView: UIScrollView)

    // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
    @objc optional func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)

    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
    @objc optional func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)

    @objc optional func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) // called on finger up as we are moving

    @objc optional func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) // called when scroll view grinds to a halt

    @objc optional func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating

    @objc optional func viewForZooming(in scrollView: UIScrollView) -> UIView? // return a view that will be scaled. if delegate returns nil, nothing happens

    @objc optional func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) // called before the scroll view begins zooming its content

    @objc optional func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) // scale between minimum and maximum. called after any 'bounce' animations

    @objc optional func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool // return a yes if you want to scroll to the top. if not defined, assumes YES

    @objc optional func scrollViewDidScrollToTop(_ scrollView: UIScrollView) // called when scrolling animation finished. may be called immediately if already at top

    /* Also see -[UIScrollView adjustedContentInsetDidChange]
     */
    @objc optional func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView)
}

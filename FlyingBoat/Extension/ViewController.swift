//
//  ViewController.swift
//  FlyingBoat
//
//  Created by Yasushi Sakita on 2021/11/16.
//

import AppKit

extension NSViewController {
    
    func present(toVC: NSViewController) {
        toVC.view.wantsLayer = true
        toVC.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
        view.addSubview(toVC.view)
        addChild(toVC)
        toVC.view.frame = view.frame
    }
    
    func presentAnimate(toVC: NSViewController) {
        
        toVC.view.wantsLayer = true
        toVC.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
        toVC.view.alphaValue = 0
        view.addSubview(toVC.view)
        addChild(toVC)
        toVC.view.frame = view.frame
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1.0
            toVC.view.animator().alphaValue = 1
        }, completionHandler:nil)
    }
}

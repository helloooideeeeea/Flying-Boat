//
//  View.swift
//  FlyingBoat
//
//  Created by Yasushi Sakita on 2021/11/11.
//
import AppKit

protocol NibLoadable {
    static var nibName: String? { get }
    static func createFromNib(in bundle: Bundle) -> Self?
}

extension NibLoadable where Self: NSView {

    static var nibName: String? {
        return String(describing: Self.self)
    }

    static func createFromNib(in bundle: Bundle = Bundle.main) -> Self? {
        guard let nibName = nibName else { return nil }
        var topLevelArray: NSArray? = nil
        bundle.loadNibNamed(NSNib.Name(nibName), owner: self, topLevelObjects: &topLevelArray)
        guard let results = topLevelArray else { return nil }
        let views = Array<Any>(results).filter { $0 is Self }
        return views.last as? Self
    }
}

extension NSView {

    func center(child: NSView) -> CGPoint {
        return CGPoint(x: abs(self.frame.width/2 - child.frame.width/2), y: abs(self.frame.height/2 - child.frame.height/2))
    }
    
}

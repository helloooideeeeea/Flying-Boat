//
//  Alert.swift
//  FlyingBoat
//
//  Created by Yasushi Sakita on 2021/11/17.
//

import AppKit

extension NSAlert {
    
    func simpleWarningDialog(window:NSWindow, message:String, onClick:@escaping() -> Void) -> Void {
        messageText = message
        addButton(withTitle: "OK")
        alertStyle = .warning
        beginSheetModal(for: window, completionHandler: { res -> Void in
            onClick()
        })
    }
}

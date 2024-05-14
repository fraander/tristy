//
//  ContextMenuTip.swift
//  Tristy
//
//  Created by Frank Anderson on 5/14/24.
//

import TipKit

struct ContextMenuTip: Tip {
    var title: Text {
        Text("Move and prioritize groceries!")
    }
    
    
    var message: Text? {
        Text("Tap and hold on the border of a grocery in the list to bring up the Context Menu with more actions.")
    }
    
    
    var image: Image? {
        Image(systemName: "exclamationmark.2")
    }
}

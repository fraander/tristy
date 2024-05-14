//
//  ContextMenuTip.swift
//  Tristy
//
//  Created by Frank Anderson on 5/14/24.
//

import TipKit

struct AddBarPasteTip: Tip {
    
    var title: Text {
        Text("Paste to quickly add groceries!")
    }
    
    
    var message: Text? {
        Text("You can paste from your clipboard to quickly add many items. Multiple lines can be pasted in!")
    }
    
    
    var image: Image? {
        Image(systemName: "doc.on.clipboard")
    }
}

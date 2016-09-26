//
//  LKActionLineView.swift
//  LemonKit-Swift
//
//  Created by 1em0nsOft on 2016/9/26.
//  Copyright © 2016年 1em0nsOft. All rights reserved.
//

import UIKit

class LKActionLineView: UIView {
    
    var item: LKActionItem

    init(frame: CGRect , actionItem: LKActionItem) {
        self.item = actionItem
        super.init(frame: frame)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTouchUpInside)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onTouchUpInside() -> Void {
        if self.item.action != nil {
            self.item.action!(self.item)
        }
    }

}

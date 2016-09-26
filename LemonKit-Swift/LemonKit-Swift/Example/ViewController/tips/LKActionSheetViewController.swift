//
//  LKActionSheetViewController.swift
//  LemonKit-Swift
//
//  Created by 1em0nsOft on 2016/9/26.
//  Copyright © 2016年 1em0nsOft. All rights reserved.
//

import UIKit

class LKActionSheetViewController: UIViewController , UIPickerViewDataSource , UIPickerViewDelegate {
    
    private var _source: Array<String>?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showBasicLKActionSheet(_ sender: UIButton) {
        let asv: LKActionSheetView = LKActionSheetView.defaultActionSheetView()
        asv.clear()
        asv.headViewHeight = 44
        asv.title = "这是一个普通的LKActionSheet"
        let cancel: LKActionItem = LKActionItem(title: "取消", textColor: .red) { (item: LKActionItem) in
            asv.hide()
        }
        asv.addAction(action: cancel, groupIndex: 0)
        asv.addActionGroup()
        asv.addAction(action: LKActionItem(title: "哈哈哈", onTouchBlock: { (item: LKActionItem) in
            print("哈哈哈")
        }), groupIndex: 1)
        asv.addAction(action: LKActionItem(title: "当然啦", onTouchBlock: { (item: LKActionItem) in
            print("当然啦")
        }), groupIndex: 1)
        asv.show()
    }
    
    @IBAction func showPickerActionSheet(_ sender: UIButton) {
        self._source = ["中山区" , "西岗区" , "高新园区" , "甘井子区" , "旅顺口区" ,
        "瓦房店" , "金州" , "普兰店"];
        let asv: LKActionSheetView = LKActionSheetView.defaultActionSheetView()
        asv.clear()
        asv.headViewHeight = 44
        asv.title = "这是一个带有PickerView的LKActionSheet"
        let cancel: LKActionItem = LKActionItem(title: "取消", textColor: .red) { (item: LKActionItem) in
            asv.hide()
        }
        asv.addAction(action: cancel, groupIndex: 0)
        asv.addAction(action: LKActionItem(title: "确认") { (item: LKActionItem) in
            print("您点击了确定")
        }, groupIndex: 0)
        
        asv.addActionGroup()
        let picker: UIPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 160))
        picker.delegate = self
        picker.dataSource = self
        asv.addAction(action: LKActionItem(customView: picker, height:  160), groupIndex: 1)
        asv.show()
    }
    
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return (self._source?.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self._source?[row]
    }

}

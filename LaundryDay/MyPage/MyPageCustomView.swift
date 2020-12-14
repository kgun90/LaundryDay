//
//  MyPageCustomView.swift
//  LaundryDay
//
//  Created by Geon Kang on 2020/12/14.
//

import UIKit

class MyPageCustomView: UIView {
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeDistanceLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var storeDialView: UIView!
    @IBOutlet weak var storeRouteView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit(){
        guard let view = loadView(nibName: "MyPageCustomView") else { return }
        
        view.frame = self.bounds
                

        self.addSubview(view)
    }
}

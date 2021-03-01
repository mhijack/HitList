//
//  RedView.swift
//  HitList
//
//  Created by Jianyuan Chen on 2021-02-02.
//  Copyright © 2021 Razeware. All rights reserved.
//

import UIKit

class RedView: UIView {

  @IBOutlet weak var redButton: UIButton!
  /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  
  @IBAction func didTapRedView(_ sender: UIButton) {
    print("did tap red view")
  }
  
}

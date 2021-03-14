//
//  RxSwift+isAnimating.swift
//  HitList
//
//  Created by Jianyuan Chen on 2021-03-13.
//  Copyright © 2021 Razeware. All rights reserved.
//

import UIKit
import RxSwift

extension Reactive where Base: UIViewController {
  
  /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
  public var isAnimating: Binder<Bool> {
    return Binder(self.base, binding: { (vc, active) in
      if active {
        vc.startAnimating()
      } else {
        vc.stopAnimating()
      }
    })
  }
  
}

//
//  Localization.swift
//  HitList
//
//  Created by Jianyuan Chen on 2021-02-03.
//  Copyright © 2021 Razeware. All rights reserved.
//

import Foundation

func AWKLocalizedString(_ key: String) -> String {
    assert(!key.contains(" "), "A key for a localized string is not allowed to contain spaces")
    return NSLocalizedString(key, comment: "")
}

enum Localization {
  
  static let Test = NSLocalizedString("Test String Modified", comment: "What will happen if I change ONLY the comment")
  static let TestWithComment = NSLocalizedString("Test Comment", comment: "This is Comment")
  
  static let AddNewLocalization = NSLocalizedString("add new localization", comment: "what will happen if I add a new localization")
  
  static let DoCapitalizationmatter = NSLocalizedString("will capitalization matter", comment: "will capitalization matter?")
  static let doCapitalizationmatter = NSLocalizedString("WILL capitalization matter", comment: "WILL capitalization matter?")
  
  static let TestInChinese = NSLocalizedString("测试翻译中文", comment: "测试翻译中文")
  
}

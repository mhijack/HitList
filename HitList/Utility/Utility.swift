//
//  Utility.swift
//  HitList
//
//  Created by Jianyuan Chen on 2021-02-04.
//  Copyright © 2021 Razeware. All rights reserved.
//

import Foundation
import MetricKit
class Utility: NSObject {
  
  func startDispatchGroup() {
    print("Starting")
    
//    let group = DispatchGroup()
//    DispatchQueue.global(qos: .utility).async {
//      print("Doing")
//      group.enter()
//      group.leave()
//    }
//
//    group.notify(queue: .main) {
//
//    }
    
    
    let concurrentQueue: DispatchQueue = DispatchQueue(label: "com.queue.Concurrent", attributes: .concurrent)
    concurrentQueue.async {
      let group = DispatchGroup()
      for i in 1...5 {
        group.enter()
        
        if Thread.isMainThread {
          print("\(i) task running in main thread")
        } else{
          print("\(i) task running in other thread")
        }
        concurrentQueue.async {
          let imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/07/Huge_ball_at_Vilnius_center.jpg")!
          let _ = try! Data(contentsOf: imageURL)
          print("\(i) finished downloading")
          group.leave()
        }
      }
      
      // Or group.wait() to block main thread until current group's tasks are completed.
      group.notify(queue: .main) {
        print("Completed")
      }
    }
  }
  
}

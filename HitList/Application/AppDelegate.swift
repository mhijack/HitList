/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import CoreData
import AVFoundation
import FirstPackage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  static let shared: AppDelegate = UIApplication.shared.delegate as! AppDelegate
  
  var dataController: DataController?
  
  var window: UIWindow?
  
  /// Test JSON
  struct TestJson: Codable {
    var name: String
    var website: URL
    
    enum CodingKeys: CodingKey {
      case name
      case website
    }
    
    /// Encode
    /// - Parameter encoder: encoder
    /// - Throws:
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      do {
        try container.encode("Jack", forKey: .name)
        try container.encode("https://www.baidu.com", forKey: .website)
      } catch let error {
        print(error.localizedDescription)
      }
    }
    
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // MARK: Testing Dispatch group
    Utility().startDispatchGroup()
    
    // MARK: Test localizations
    print(Localization.TestWithComment)
    print(Localization.AddNewLocalization)
    
    
    dataController = DataController() {
      //Complete user interface initialization
    }
    
    // MARK: Tells why app is brought to foreground
    if let keys = launchOptions?.keys {
      if keys.contains(.remoteNotification) {
        // TODO: 
      }
    }
    
    
    let json = TestJson(name: "Jack", website: URL(string: "https:www.google.com")!)
    
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    do {
      let encoded = try encoder.encode(json)
      print(encoded)
      
      let decoder = JSONDecoder()
      let decoded: TestJson = try decoder.decode(TestJson.self, from: encoded)
      print(type(of: decoded.website))
    } catch let error {
      debugPrint(error.localizedDescription)
    }
    
    
    // MARK: Test Swift Package Manager
    let names = ["jack", "melody"]
    names.printHi()
    
    
    
    return true
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Whatever reason the app is closed, save context.
    // Other times, we can interact with data in memory (aka context)
    dataController?.saveContext()
  }
  
}

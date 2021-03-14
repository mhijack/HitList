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

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let justSomeTest = AWKLocalizedString("just-some-test")
    print(justSomeTest)
    title = "The List"
    
//    tableView.dragDelegate = self
//    tableView.dropDelegate = self
//    tableView.dragInteractionEnabled = true
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView.contentInsetAdjustmentBehavior = .always
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    fetchPeople()
  }
  
  @IBAction func didTapPage2(_ sender: Any) {
    print("hi")
    performSegue(withIdentifier: "Page2Segue", sender: self)
  }
  
  @IBAction func didTapVideoButton(_ sender: Any) {
    
  }
  
  /*
   Fetch
   */
  private func fetchPeople() {
    let dataController = AppDelegate.shared.dataController
    _ = dataController?.initializePersonFetchedResultsController()
    dataController?.personController.delegate = self
  }
  
  /*
   Add name
   */
  @IBAction func addName(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
      
      guard let textField = alert.textFields?.first,
            let nameToSave = textField.text else {
        return
      }
      
      self.save(name: nameToSave)
      self.tableView.reloadData()
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    alert.addTextField()
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true)
  }
  
  /*
   Save
   */
  func save(name: String) {
    guard let managedContext = AppDelegate.shared.dataController?.persistentContainer.viewContext else {
      return
    }
    let person = Person(context: managedContext)
    person.setValue(name, forKeyPath: "name")
    
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
  
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let person = AppDelegate.shared.dataController?.personController.object(at: indexPath) as? Person else {
      return
    }
    
    print(person)
    let name = person.name ?? "nil"
    person.name = "\(name)+\(name)"
    AppDelegate.shared.dataController?.saveContext()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = AppDelegate.shared.dataController?.personController.sections else {
      fatalError("No sections in fetchedResultsController")
    }
    let sectionInfo = sections[section]
    return sectionInfo.numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    // Set up the cell
    guard let person = AppDelegate.shared.dataController?.personController?.object(at: indexPath) as? Person else {
      fatalError("Attempt to configure cell without a managed object")
    }
    
    cell.textLabel?.text = person.value(forKeyPath: "name") as? String
    //Populate the cell from the object
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    guard let sections = AppDelegate.shared.dataController?.personController.sections?.count else {
      assert(true, "Person fetched result controller section empty")
      return 0
    }
    return sections
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    switch editingStyle {
    case .delete:
      // handle delete (by removing the data from your array and updating the tableview)
      let dataController = AppDelegate.shared.dataController
      _ = dataController?.persistentContainer.viewContext
      guard let person = dataController?.personController.object(at: indexPath) as? Person else {
        return
      }
      print(person)
      dataController?.persistentContainer.viewContext.delete(person)
      dataController?.saveContext()
      break
    case .insert:
      break
    default:
      break
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.alpha = 0
    let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 0)
    cell.layer.transform = transform
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
      cell.alpha = 1
      cell.layer.transform = CATransform3DIdentity
    }, completion: nil)
  }
  
}

// MARK: - , UITableViewDropDelegate
extension ViewController: UITableViewDropDelegate {
  
  func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
  }
  
  func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
    return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
  }
}

// MARK: - UITableViewDragDelegate
extension ViewController: UITableViewDragDelegate {
  
  func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let dragItem = UIDragItem(itemProvider: NSItemProvider())
    //    dragItem.localObject = data[indexPath.row]
    print(dragItem)
    return [dragItem]
  }
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    // Update the model
    let dataController = AppDelegate.shared.dataController
    let context = dataController?.persistentContainer.viewContext
    
    guard var objects = dataController?.personController.fetchedObjects as? [NSManagedObject] else {
      return
    }
    
    let mover = objects[sourceIndexPath.row]
    objects.remove(at: sourceIndexPath.row)
    objects.insert(mover, at: destinationIndexPath.row)
    
    var i = 0
    for object in objects {
      
      object.setValue(i += 1, forKey: "orderPosition")
    }
    context?.delete(mover)
    context?.insert(mover)
    dataController?.saveContext()
  }
  
}

// MARK: - NSFetchedResultsControllerDelegate
extension ViewController: NSFetchedResultsControllerDelegate {
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
    case .insert:
      tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
    case .delete:
      tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
    case .move:
      tableView.reloadSections([sectionIndex], with: .automatic)
      break
    case .update:
      break
    @unknown default:
      assertionFailure()
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      tableView.insertRows(at: [newIndexPath!], with: .fade)
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .fade)
    case .update:
      tableView.reloadRows(at: [indexPath!], with: .fade)
    case .move:
      tableView.moveRow(at: indexPath!, to: newIndexPath!)
    @unknown default:
      assertionFailure()
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
}

protocol Database {
  func connect()
}

class DatabaseController {
  private let database: Database
  
  init(db: Database) {
    self.database = db
}
  func connectDatabase() {
    database.connect()
  }
}
class NetworkRequest: Database {
  func connect() {
    // Connect to the database
  }
}

//
//  DataController.swift
//  HitList
//
//  Created by Jianyuan Chen on 2021-01-26.
//  Copyright © 2021 Razeware. All rights reserved.
//

import UIKit
import CoreData

class DataController: NSObject {
  
  var persistentContainer: NSPersistentContainer
  var personController: NSFetchedResultsController<NSFetchRequestResult>!
  
  init(completionClosure: @escaping () -> ()) {
    persistentContainer = NSPersistentContainer(name: "DataModel")
    persistentContainer.loadPersistentStores() { (description, error) in
      if let error = error {
        fatalError("Failed to load Core Data stack: \(error)")
      }
      completionClosure()
    }
    persistentContainer.newBackgroundContext()
  }
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate.
        /// You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  func initializePersonFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
    // request.predicate = NSPredicate(format: "name == %@", "jack")
    let sort = NSSortDescriptor(key: "name", ascending: true)
    request.sortDescriptors = [sort]
    request.fetchBatchSize = 10
    //    request.fetchLimit = 10
    //    request.fetchOffset = 10
    let fetchResultsController: NSFetchedResultsController = NSFetchedResultsController(
      fetchRequest: request,
      managedObjectContext: persistentContainer.viewContext,
      sectionNameKeyPath: nil,
      cacheName: nil
    )
    personController = fetchResultsController
    
    do {
      // This call retrieves the initial data to be displayed and causes the NSFetchedResultsController instance to start monitoring the managed object context for changes.
      try fetchResultsController.performFetch()
    } catch let error {
      print(error)
      fatalError(error.localizedDescription)
    }
    
    return fetchResultsController
  }
  
}

//
//  PersistentController.swift
//  Outline
//
//  Created by Seungui Moon on 10/17/23.
//

import CoreData
import SwiftUI

struct PersistenceController {
  static let shared = PersistenceController()

  let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "UserCoreDataModel")
        container.loadPersistentStores { _, error in
          if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
          }
        }
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
          do {
            try context.save()
          } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
        }
     }
}

//
//  DataController.swift
//  FoodTracker
//
//  Created by Arno Smit on 24/06/15.
//  Copyright (c) 2015 Namib Lost in Sweden. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataController {
    
    class func jsonAsUSDAIdAndNameSearchResults (json: NSDictionary) -> [(name: String, idValue: String)] {
        
        var usdaItemsSearchResults:[(name : String, idValue: String)] = []
        var searchResult: (name: String, idValue : String)
        
        if json["hits"] != nil {
            let results:[AnyObject] = json["hits"]! as! [AnyObject]
            for itemDictionary in results {
                if itemDictionary["_id"] != nil {
                    if itemDictionary["fields"] != nil {
                        let fieldsDictionary = itemDictionary["fields"] as! NSDictionary
                        if fieldsDictionary["item_name"] != nil {
                            let idValue:String = itemDictionary["_id"]! as! String
                            let name:String = fieldsDictionary["item_name"]! as! String
                            searchResult = (name : name, idValue : idValue)
                            usdaItemsSearchResults += [searchResult]
                        }
                    }
                }
            }
        }
        return usdaItemsSearchResults
        
    }
    
    
    func saveUSDAItemForId(idValue: String, json: NSDictionary) {
        
        if json["hits"] != nil {
            let results:[AnyObject] = json["hits"]! as! [AnyObject]
            
            for itemDictionary in results {
                
                if itemDictionary["_id"] != nil && itemDictionary["keyId"] as! String == idValue {
                    
                    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
                    
                    var requestForUSDAItem = NSFetchRequest(entityName: "USDAItem")
                    
                    let itemDictionaryId = itemDictionary["_id"]! as! String
                    let predicate = NSPredicate(format: "idValue == %@", itemDictionaryId)
                    requestForUSDAItem.predicate = predicate
                    
                    var error: NSError?
                    
                    var items = managedObjectContext?.executeFetchRequest(requestForUSDAItem, error: &error)
                    
                    if items?.count != 0 {
                        // Item is already saved so pass
                        return
                    }
                    else {
                        println("Let's save this to CoreData")
                        
                        let entityDescription = NSEntityDescription.entityForName("USDAItem", inManagedObjectContext: managedObjectContext!)
                        let usdaItem = USDAItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
                        usdaItem.idValue = itemDictionary["_id"]! as! String
                        usdaItem.dateAdded = NSDate()
                        
                        if itemDictionary["fields"] != nil {
                            let fieldsDictionary = itemDictionary["fields"]! as! NSDictionary
                            if fieldsDictionary["item_name"] != nil {
                                usdaItem.name = fieldsDictionary["item_name"]! as! String
                                
                            }
                            
                            if fieldsDictionary["usda_fields"] != nil {
                                let usdaFieldsDictionary = fieldsDictionary["usda_fields"]! as! NSDictionary
                                
                                // Save Calcium
                                if usdaFieldsDictionary["CA"] != nil {
                                    let calciumDictionary = usdaFieldsDictionary["CA"]! as! NSDictionary
                                    let calciumValue: AnyObject = calciumDictionary["value"]!
                                    usdaItem.calcium = "\(calciumValue)"
                                }
                                else {
                                    usdaItem.calcium = "0"
                                }
                                
                                // Save Carbohydrate
                                if usdaFieldsDictionary["CHODF"] != nil {
                                    let carbohydrateDictionary = usdaFieldsDictionary["CHODF"]! as! NSDictionary
                                    let carbohydrateValue: AnyObject = carbohydrateDictionary["value"]!
                                    usdaItem.carbohydrate = "\(carbohydrateValue)"
                                }
                                else {
                                    usdaItem.carbohydrate = "0"
                                }
                                
                                // Save Fat
                                if usdaFieldsDictionary["FAT"] != nil {
                                    let fatDictionary = usdaFieldsDictionary["FAT"]! as! NSDictionary
                                    let fatValue: AnyObject = fatDictionary["value"]!
                                    usdaItem.fatTotal = "\(fatValue)"
                                }
                                else {
                                    usdaItem.fatTotal = "0"
                                }
                                
                                // Save Cholesterol
                                if usdaFieldsDictionary["CHOLE"] != nil {
                                    let cholesterolDictionary = usdaFieldsDictionary["CHOLE"]! as! NSDictionary
                                    let cholesterolValue: AnyObject = cholesterolDictionary["value"]!
                                    usdaItem.cholesterol = "\(cholesterolValue)"
                                }
                                else {
                                    usdaItem.cholesterol = "0"
                                }
                                
                                // Save ProteinValue
                                if usdaFieldsDictionary["PROCNT"] != nil {
                                    let proteinDictionary = usdaFieldsDictionary["PROCNT"]! as! NSDictionary
                                    let proteinValue: AnyObject = proteinDictionary["value"]!
                                    usdaItem.protein = "\(proteinValue)"
                                }
                                else {
                                    usdaItem.protein = "0"
                                }
                                
                                // Save Sugar Value
                                if usdaFieldsDictionary["SUGAR"] != nil {
                                    let sugarDictionary = usdaFieldsDictionary["SUGAR"]! as! NSDictionary
                                    let sugarValue: AnyObject = sugarDictionary["value"]!
                                    usdaItem.sugar = "\(sugarValue)"
                                }
                                else {
                                    usdaItem.sugar = "0"
                                }
                                
                                // Save Vitamin C
                                if usdaFieldsDictionary["VITC"] != nil {
                                    let vitaminCDictionary = usdaFieldsDictionary["VITC"]! as! NSDictionary
                                    let vitaminCValue: AnyObject = vitaminCDictionary["value"]!
                                    usdaItem.vitaminC = "\(vitaminCValue)"
                                }
                                else {
                                    usdaItem.vitaminC = "0"
                                }
                                
                                // Energy
                                if usdaFieldsDictionary["ENERC_KCAL"] != nil {
                                    let energyDictionary = usdaFieldsDictionary["ENERC_KCAL"]! as! NSDictionary
                                    let energyValue: AnyObject = energyDictionary["value"]!
                                    usdaItem.energy = "\(energyValue)"
                                }
                                else {
                                    usdaItem.energy = "0"
                                }
                                
                                (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
                                
                            }
                            

                        }
                    }
                }
            }
        }
    }
    
}

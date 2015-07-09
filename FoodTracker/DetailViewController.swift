//
//  DetailViewController.swift
//  FoodTracker
//
//  Created by Arno Smit on 03/06/15.
//  Copyright (c) 2015 Namib Lost in Sweden. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!

    var usdaItem:USDAItem?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "usdaItemDidComplete:", name: kUSDAItemCompleted, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if usdaItem != nil {
            textView.attributedText = createAttributedString(usdaItem!)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func usdaItemDidComplete(notification: NSNotification) {
        println("USDAItemDidComplete in DetailVC")
        
        usdaItem = notification.object as? USDAItem
        
        if self.isViewLoaded() && self.view.window != nil {
            textView.attributedText = createAttributedString(usdaItem)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func eatItBarButtonItemPressed(sender: UIBarButtonItem) {
    }
    
    func createAttributedString(usdaItem: USDAItem!) -> NSAttributedString {
        
        var itemAttributedString = NSMutableAttributedString()
        
        // Set the paragraph style
        var centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = NSTextAlignment.Center
        centeredParagraphStyle.lineSpacing = 10.0
        
        // Apply the paragraph style
        var titleAttributesDictionary = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont.boldSystemFontOfSize(22.0),
            NSParagraphStyleAttributeName: centeredParagraphStyle
        ]
        
        let titleString = NSAttributedString(string: "\(usdaItem.name)\n", attributes: titleAttributesDictionary)
        
        itemAttributedString.appendAttributedString(titleString)
        
        var leftAlignedParagraphStyle = NSMutableParagraphStyle()
        leftAlignedParagraphStyle.alignment = NSTextAlignment.Left
        leftAlignedParagraphStyle.lineSpacing = 20.0
        
        var styleFirstWordAttributesDictionary = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0),
            NSParagraphStyleAttributeName: leftAlignedParagraphStyle
        ]
        
        var style1AttributesDictionary = [
            NSForegroundColorAttributeName: UIColor.darkGrayColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(18.0),
            NSParagraphStyleAttributeName: leftAlignedParagraphStyle
        ]
        
        var style2AttributesDictionary = [
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(18.0),
            NSParagraphStyleAttributeName: leftAlignedParagraphStyle
        ]
        
        // Add styling attr to Calcium and append to itemAttributedString
        let calciumTitleString = NSAttributedString(string: "Calcium ", attributes: styleFirstWordAttributesDictionary)
        let calciumBodyString = NSAttributedString(string: "\(usdaItem.calcium)% \n", attributes: style1AttributesDictionary)
        itemAttributedString.appendAttributedString(calciumTitleString)
        itemAttributedString.appendAttributedString(calciumBodyString)
        
        // Carbohydrates
        let carbohydrateTitleString = NSAttributedString(string: "Carbohydrates ", attributes: styleFirstWordAttributesDictionary)
        let carbohydrateBodyString = NSAttributedString(string: "\(usdaItem.carbohydrate)% \n", attributes: style2AttributesDictionary)
        itemAttributedString.appendAttributedString(carbohydrateTitleString)
        itemAttributedString.appendAttributedString(carbohydrateBodyString)
        
        
        // Cholesterol
        let cholesterolTitleString = NSAttributedString(string: "Cholesterol ", attributes: styleFirstWordAttributesDictionary)
        let cholesterolBodyString = NSAttributedString(string: "\(usdaItem.cholesterol) % \n", attributes: style1AttributesDictionary)
        itemAttributedString.appendAttributedString(cholesterolTitleString)
        itemAttributedString.appendAttributedString(cholesterolBodyString)
        
        
        return itemAttributedString
    }
    


}

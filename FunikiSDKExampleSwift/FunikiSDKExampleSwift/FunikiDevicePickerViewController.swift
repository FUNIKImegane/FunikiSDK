//
//  Created by Matilde Inc.
//  Copyright (c) 2015 FUN'IKI Project. All rights reserved.
//

import UIKit

class FunikiDevicePickerViewController: UITableViewController, MAFunikiManagerDelegate {
    
    let funikiManager = MAFunikiManager.sharedInstance()
    
    // MARK: - UITableViewController
    override func viewDidLoad(){
        super.viewDidLoad()
        self.title = "雰囲気メガネを選択"
    }
    
    override func viewWillAppear(animated: Bool) {
        funikiManager.delegate = self
        funikiManager.startSelectingDevice()
        
        self.tableView.reloadData()
        
        super.viewWillAppear(animated)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // MARK: - MAFunikiManagerDelegate
    func funikiManager(manager: MAFunikiManager!, didUpdateDiscoveredPeripherals peripherals: [AnyObject]!) {
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource/Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return funikiManager.discoveredPeripherals.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath) as UITableViewCell
        
        let discoveredPeripheral = funikiManager.discoveredPeripherals[indexPath.row] as! MADiscoveredPeripheral
        cell.textLabel?.text = discoveredPeripheral.peripheral.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let discoveredPeripheral = funikiManager.discoveredPeripherals[indexPath.row] as! MADiscoveredPeripheral
        funikiManager.connectPeripheral(discoveredPeripheral)
        funikiManager.stopSelectingDevice()
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    // MARK: - Action
    @IBAction func cancel(sender:AnyObject!) {
        funikiManager.stopSelectingDevice()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

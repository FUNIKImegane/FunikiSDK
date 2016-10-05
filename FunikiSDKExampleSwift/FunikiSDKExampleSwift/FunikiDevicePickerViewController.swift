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
    
    override func viewWillAppear(_ animated: Bool) {
        funikiManager?.delegate = self
        funikiManager?.startSelectingDevice()
        
        self.tableView.reloadData()
        
        super.viewWillAppear(animated)
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    
    
    // MARK: - MAFunikiManagerDelegate
    private func funikiManager(manager: MAFunikiManager!, didUpdateDiscoveredPeripherals peripherals: [AnyObject]!) {
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource/Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = funikiManager!.discoveredPeripherals.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as UITableViewCell
        
        let discoveredPeripheral = funikiManager?.discoveredPeripherals[indexPath.row] as! MADiscoveredPeripheral
        cell.textLabel?.text = discoveredPeripheral.peripheral.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let discoveredPeripheral = funikiManager?.discoveredPeripherals[indexPath.row] as! MADiscoveredPeripheral
        funikiManager?.connect(discoveredPeripheral)
        funikiManager?.stopSelectingDevice()
        self.dismiss(animated: true, completion:nil)
    }
    
    // MARK: - Action
    @IBAction func cancel(sender:AnyObject!) {
        funikiManager?.stopSelectingDevice()
        self.dismiss(animated: true, completion: nil)
    }
}

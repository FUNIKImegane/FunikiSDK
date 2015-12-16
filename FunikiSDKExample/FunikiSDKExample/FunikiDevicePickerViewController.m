//
//  Created by Matilde Inc.
//  Copyright (c) 2015 Fun'iki Project. All rights reserved.
//

#import "FunikiDevicePickerViewController.h"
#import "MAFunikiManager.h"

@interface FunikiDevicePickerViewController () <MAFunikiManagerDelegate>

@end

@implementation FunikiDevicePickerViewController

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"雰囲気メガネを選択";
}

- (void)viewWillAppear:(BOOL)animated
{
    [[MAFunikiManager sharedInstance] setDelegate:self];
    [[MAFunikiManager sharedInstance] startSelectingDevice];
    
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - MAFunikiManagerDelegate
- (void)funikiManager:(MAFunikiManager *)sdk didUpdateDiscoveredPeripherals:(NSArray *)peripherals
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [[[MAFunikiManager sharedInstance] discoveredPeripherals] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    MADiscoveredPeripheral *discoveredPeripheral = [[[MAFunikiManager sharedInstance] discoveredPeripherals] objectAtIndex:indexPath.row];
    cell.textLabel.text = discoveredPeripheral.peripheral.name;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *peripherals = [[MAFunikiManager sharedInstance] discoveredPeripherals];
    MADiscoveredPeripheral *selectedPeripheral = peripherals[indexPath.row];
    if (selectedPeripheral){
        [[MAFunikiManager sharedInstance] connectPeripheral:selectedPeripheral];
    }
    [[MAFunikiManager sharedInstance] stopSelectingDevice];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Action
- (IBAction)cancel:(id)sender
{
    [[MAFunikiManager sharedInstance] stopSelectingDevice];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
}

@end

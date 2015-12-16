//
//  Created by Matilde Inc.
//  Copyright (c) 2015 FUN'IKI Project. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;
@interface MADiscoveredPeripheral : NSObject
@property (nonatomic, strong) NSNumber *rssi;
@property (nonatomic, strong) CBPeripheral *peripheral;
@end

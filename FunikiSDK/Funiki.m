//
//  Funiki.m
//
//  Created by Matilde Inc.
//  Copyright (c) 2015 FUN'IKI Project. All rights reserved.
//

#import "Funiki.h"

/**
 * これは雰囲気メガネを簡単に光らせるための、サンプル・コードです。 SDKの全ての機能を使用するには、MAFunikiManagerを使用してください。
 * @see MAFunikiManager
 */
@interface Funiki () <MAFunikiManagerDataDelegate, MAFunikiManagerDelegate>
{
    MAFunikiManager *_funikiManager;
    UIColor *_waitingColor;
}
@end

@implementation Funiki

+ (void)prepare
{
    [Funiki sharedInstance];
}

+ (void)changeColor:(UIColor *)color
{
    if (!color){
        NSLog(@"changeColorの引数としてnilが指定されています。nilを指定することはできません。");
        return;
    }
    [[Funiki sharedInstance] changeColor:color];
}

- (instancetype)init
{
    self = [super init];
    if (self){
        _funikiManager = [MAFunikiManager sharedInstance];
        _funikiManager.delegate = self;
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static id singletonInstance = nil;
    if (!singletonInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singletonInstance = [[super allocWithZone:NULL] init];
        });
    }
    return singletonInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)changeColor:(UIColor *)color
{
    if ([_funikiManager isConnected]){
        [_funikiManager changeColor:color];
        NSLog(@"雰囲気メガネの色を %@ に変更しました。", color);
    }
    else {
        NSLog(@"雰囲気メガネに接続しています...");
        _waitingColor = color;
        [_funikiManager startSelectingDevice];
    }
}

- (void)funikiManager:(MAFunikiManager *)manager didUpdateDiscoveredPeripherals:(NSArray *)peripherals
{
    if (peripherals.count > 0){
        
        MADiscoveredPeripheral *discovered = peripherals.firstObject;
        [_funikiManager connectPeripheral:discovered];
        [_funikiManager stopSelectingDevice];
    }
}

- (void)funikiManager:(MAFunikiManager *)manager didUpdateCentralState:(CBCentralManagerState)state
{
    switch (state) {
            
        case CBCentralManagerStateUnknown:
            NSLog(@"Bluetoothの状況が不明です。");
            break;
            
        case CBCentralManagerStateResetting:
            NSLog(@"Bluetoothをシステムがリセットしています。");
            break;
            
        case CBCentralManagerStateUnsupported:
            NSLog(@"このiOSデバイスは、Bluetooth LEをサポートしていません。");
            break;
            
        case CBCentralManagerStateUnauthorized:
            NSLog(@"Bluetoothの利用をユーザが許可していません。");
            break;
            
        case CBCentralManagerStatePoweredOff:
            NSLog(@"Bluetoothがオフになっています。");
            break;
            
        case CBCentralManagerStatePoweredOn:
            NSLog(@"Bluetoothが利用できます。");
            break;
            
        default:
            break;
    }
}

- (void)funikiManagerDidDisconnect:(MAFunikiManager *)manager error:(NSError *)error
{
    NSLog(@"雰囲気メガネに接続されていません。");
}

- (void)funikiManagerDidConnect:(MAFunikiManager *)manager
{
    NSLog(@"雰囲気メガネに接続しました。");
    if (_waitingColor){
        [self changeColor:_waitingColor];
        _waitingColor = nil;
    }
}

@end

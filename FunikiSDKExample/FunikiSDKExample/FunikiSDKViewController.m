//
//  Created by Matilde Inc.
//  Copyright (c) 2015 Fun'iki Project. All rights reserved.
//

#import "FunikiSDKViewController.h"
#import "MAFunikiManager.h"

@interface FunikiSDKViewController () <MAFunikiManagerDelegate, MAFunikiManagerDataDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *volumeSegmentedControl;
@property (weak, nonatomic) IBOutlet UISlider *frequencySlider;
@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *batteryLabel;

@end

@implementation FunikiSDKViewController

#pragma mark -
- (void)updateConnectionStatus
{
    if ([MAFunikiManager sharedInstance].isConnected){
        self.connectionLabel.text = @"接続済み";
    }
    else {
        self.connectionLabel.text = @"未接続";
    }
}

- (void)updateBatteryLevel
{
    switch ([[MAFunikiManager sharedInstance] batteryLevel]){
        case MAFunikiManagerBatteryLevelUnknown:
            self.batteryLabel.text = @"バッテリー残量:不明";
            break;
        
        case MAFunikiManagerBatteryLevelLow:
            self.batteryLabel.text = @"バッテリー残量:少ない";
            break;
            
        case MAFunikiManagerBatteryLevelMedium:
            self.batteryLabel.text = @"バッテリー残量:中";
            break;
        
        case MAFunikiManagerBatteryLevelHigh:
            self.batteryLabel.text = @"バッテリー残量:多い";
            break;
            
        default:
            break;
    }
}

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.volumeSegmentedControl.selectedSegmentIndex = 2;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[MAFunikiManager sharedInstance] setDelegate:self];
    [[MAFunikiManager sharedInstance] setDataDelegate:self];
    
    [self updateConnectionStatus];
    [self updateBatteryLevel];
    [self buzzerFrequencyChanged:nil];
    
    [super viewWillAppear:animated];
}

#pragma mark - MAFunikiManagerDelegate
- (void)funikiManagerDidConnect:(MAFunikiManager *)manager
{
    NSLog(@"SDK Version%@", [MAFunikiManager funikiSDKVersionString]);
    NSLog(@"Firmware Revision%@", manager.firmwareRevision);
    
    [self updateConnectionStatus];
    [self updateBatteryLevel];
}

- (void)funikiManagerDidDisconnect:(MAFunikiManager *)manager error:(NSError *)error
{
    NSLog(@"%@", error);
    
    [self updateConnectionStatus];
    [self updateBatteryLevel];
}

- (void)funikiManager:(MAFunikiManager *)manager didUpdateCentralState:(CBCentralManagerState)state
{
    NSLog(@"CentralState:%ld", (long)state);
    
    [self updateConnectionStatus];
    [self updateBatteryLevel];
}

- (void)funikiManager:(MAFunikiManager *)manager didUpdateBatteryLevel:(MAFunikiManagerBatteryLevel)batteryLevel
{
    [self updateBatteryLevel];
}

#pragma mark - MAFunikiManagerDataDelegate
- (void)funikiManager:(MAFunikiManager *)manager didUpdateMotionData:(MAFunikiMotionData *)motionData
{
    NSLog(@"%@", motionData);
}

- (void)funikiManager:(MAFunikiManager *)manager didPushButton:(MAFunikiManagerButtonEventType)buttonEvent
{
    
}

#pragma mark - Action

- (IBAction)red:(id)sender
{
    if ([[MAFunikiManager sharedInstance] isConnected]){
        [[MAFunikiManager sharedInstance] changeLeftColor:[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f]
                                               rightColor:[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f]
                                                 duration:1.0
                                          buzzerFrequency:[self frequencyFromSlider]
                                             buzzerVolume:[self selectedBuzzerVolume]];
    }
}

- (IBAction)green:(id)sender
{
    if ([[MAFunikiManager sharedInstance] isConnected]){
        [[MAFunikiManager sharedInstance] changeLeftColor:[UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:1.0f]
                                               rightColor:[UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:1.0f]
                                                 duration:1.0
                                          buzzerFrequency:[self frequencyFromSlider]
                                             buzzerVolume:[self selectedBuzzerVolume]];
    }
}

- (IBAction)blue:(id)sender
{
    if ([[MAFunikiManager sharedInstance] isConnected]){
        [[MAFunikiManager sharedInstance] changeLeftColor:[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f]
                                               rightColor:[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f]
                                                 duration:1.0
                                          buzzerFrequency:[self frequencyFromSlider]
                                             buzzerVolume:[self selectedBuzzerVolume]];
    }
}

- (IBAction)stop:(id)sender
{
    [[MAFunikiManager sharedInstance] changeLeftColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]
                                           rightColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]
                                             duration:1.0];
}

- (IBAction)buzzerFrequencyChanged:(id)sender
{
    // ラベルに周波数を表示
    self.frequencyLabel.text = [NSString stringWithFormat:@"%0.0ld",(long)[self frequencyFromSlider]];
}

#pragma mark - UI->Value
- (MAFunikiManagerBuzzerVolume)selectedBuzzerVolume
{
    MAFunikiManagerBuzzerVolume volume;
    switch (self.volumeSegmentedControl.selectedSegmentIndex) {
        case 0:
            volume = MAFunikiManagerBuzzerVolumeMute;
            break;
            
        case 1:
            volume = MAFunikiManagerBuzzerVolumeLow;
            break;
            
        case 2:
            volume = MAFunikiManagerBuzzerVolumeMedium;
            break;
            
        case 3:
            volume = MAFunikiManagerBuzzerVolumeLoud;
            break;
            
        default:
            volume = MAFunikiManagerBuzzerVolumeMute;
            break;
    }
    return volume;
}

- (NSInteger)frequencyFromSlider
{
    NSInteger value = pow(self.frequencySlider.value,2);
    // 雰囲気メガネが発音可能な周波数に丸めます。
    NSInteger freq = [[MAFunikiManager sharedInstance] roundedBuzzerFrequency:value];
    return freq;
}

@end

//
//  Created by Matilde Inc.
//  Copyright (c) 2015 Fun'iki Project. All rights reserved.
//

#import "FunikiSDKMotionViewController.h"
#import "MAFunikiManager.h"
@interface FunikiSDKMotionViewController() <MAFunikiManagerDelegate, MAFunikiManagerDataDelegate>
{
    CGRect _baseSize;
    
    CGRect _accXRect;
    CGRect _accYRect;
    CGRect _accZRect;
    CGRect _rotXRect;
    CGRect _rotYRect;
    CGRect _rotZRect;
}

@property (weak, nonatomic) IBOutlet UIView *accXView;
@property (weak, nonatomic) IBOutlet UIView *accYView;
@property (weak, nonatomic) IBOutlet UIView *accZView;
@property (weak, nonatomic) IBOutlet UIView *rotXView;
@property (weak, nonatomic) IBOutlet UIView *rotYView;
@property (weak, nonatomic) IBOutlet UIView *rotZView;

@property (weak, nonatomic) IBOutlet UISwitch *sensorSwitch;

@end

@implementation FunikiSDKMotionViewController

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _baseSize = self.accXView.frame;
    _baseSize.size.width = _baseSize.size.width / 2;
    
    _accXRect = self.accXView.frame;
    _accYRect = self.accYView.frame;
    _accZRect = self.accZView.frame;
    _rotXRect = self.rotXView.frame;
    _rotYRect = self.rotYView.frame;
    _rotZRect = self.rotZView.frame;
    
    [self setBarsHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[MAFunikiManager sharedInstance] setDelegate:self];
    [[MAFunikiManager sharedInstance] setDataDelegate:self];
    
    [self updateSensorSwitch];
    
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(void)setBarsHidden:(BOOL)hidden
{
    self.accXView.hidden = hidden;
    self.accYView.hidden = hidden;
    self.accZView.hidden = hidden;
    self.rotXView.hidden = hidden;
    self.rotYView.hidden = hidden;
    self.rotZView.hidden = hidden;
}

- (void)updateSensorSwitch
{
    if ([MAFunikiManager sharedInstance].isConnected){
        self.sensorSwitch.enabled = YES;
    }
    else {
        self.sensorSwitch.enabled = NO;
        [self.sensorSwitch setOn:NO animated:YES];
    }
}

#pragma mark - MAFunikiManagerDelegate
- (void)funikiManagerDidConnect:(MAFunikiManager *)manager
{
    NSLog(@"SDK Version%@", [MAFunikiManager funikiSDKVersionString]);
    NSLog(@"Firmware Revision%@", manager.firmwareRevision);
    
    [self updateSensorSwitch];
}

- (void)funikiManagerDidDisconnect:(MAFunikiManager *)manager error:(NSError *)error
{
    NSLog(@"%@", error);
    [self updateSensorSwitch];
}

- (void)funikiManager:(MAFunikiManager *)manager didUpdateCentralState:(CBCentralManagerState)state
{
    NSLog(@"CentralState:%ld", (long)state);
    
    [self updateSensorSwitch];
}

#pragma mark - MAFunikiManagerDelegate

- (void)funikiManager:(MAFunikiManager *)manager didUpdateMotionData:(MAFunikiMotionData *)motionData
{
    _accXRect.size.width = motionData.acceleration.x * _baseSize.size.width;
    _accYRect.size.width = motionData.acceleration.y * _baseSize.size.width;
    _accZRect.size.width = motionData.acceleration.z * _baseSize.size.width;
    _rotXRect.size.width = ((motionData.rotationRate.x * _baseSize.size.width) / 250.0) * 2.0;
    _rotYRect.size.width = ((motionData.rotationRate.y * _baseSize.size.width) / 250.0) * 2.0;
    _rotZRect.size.width = ((motionData.rotationRate.z * _baseSize.size.width) / 250.0) * 2.0;
    
    self.accXView.frame = _accXRect;
    self.accYView.frame = _accYRect;
    self.accZView.frame = _accZRect;
    self.rotXView.frame = _rotXRect;
    self.rotYView.frame = _rotYRect;
    self.rotZView.frame = _rotZRect;
}

- (void)funikiManager:(MAFunikiManager *)manager didPushButton:(MAFunikiManagerButtonEventType)buttonEventType
{
    NSString *message = @"";
    switch (buttonEventType) {
        case MAFunikiManagerButtonEventTypeSinglePush:
            message = @"ButtonEvnetTypeSinglePush";
            break;
            
        case MAFunikiManagerButtonEventTypeDoublePush:
            message = @"ButtonEventTypeDoublePush";
            break;
            
        default:
            message = @"ButtonEventTypeUnknown";
            break;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DidPushButton" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Action
- (IBAction)switchDidChange:(UISwitch *)sender
{
    if (sender.on){
        // モーションセンサーを起動します。
        [[MAFunikiManager sharedInstance] startMotionSensor];
        [self setBarsHidden:NO];
    }else{
        // モーションセンサーを停止します。
        [[MAFunikiManager sharedInstance] stopMotionSensor];
        [self setBarsHidden:YES];
    }
}

@end

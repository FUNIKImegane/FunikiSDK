//
//  MAFunikiMotionData.h
//
//  Created by Matilde Inc.
//  Copyright (c) 2015 FUN'IKI Project. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MAFunikiAccelerationData.h"
#import "MAFunikiRotationRateData.h"

@interface MAFunikiMotionData : NSObject
@property (strong) MAFunikiAccelerationData *acceleration;
@property (strong) MAFunikiRotationRateData *rotationRate;
@end

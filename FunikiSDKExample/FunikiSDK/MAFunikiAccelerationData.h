//
//  MAFunikiAcceleration.h
//
//  Created by Matilde Inc.
//  Copyright (c) 2015 FUN'IKI Project. All rights reserved.
//

#import <Foundation/Foundation.h>


/// 加速度センサのデータを格納する 計測できる値は ±2G
@interface MAFunikiAccelerationData : NSObject

/// X軸方向の加速度 単位はG
@property (assign) double x;

/// Y軸方向の加速度 単位はG
@property (assign) double y;

/// Z軸方向への加速度 単位はG
@property (assign) double z;

- (instancetype)initWithX:(double)x Y:(double) y Z:(double)z;

@end

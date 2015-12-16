//
//  MAFunikiRotationData.h
//
//  Created by Matilde Inc.
//  Copyright (c) 2015 FUN'IKI Project. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 角速度センサのデータを格納する 計測できる値は ±250degree/second
@interface MAFunikiRotationRateData : NSObject

/// X軸の角速度 単位はdegree/second
@property (assign) double x;

/// Y軸の角速度 単位はdegree/second
@property (assign) double y;

/// Z軸の角速度 単位はdegree/second
@property (assign) double z;

- (instancetype)initWithX:(double)x Y:(double)y Z:(double)z;

@end

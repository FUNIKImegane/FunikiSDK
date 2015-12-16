//
//  Funiki.h
//
//  Created by Matilde Inc.
//  Copyright (c) 2015 FUN'IKI Project. All rights reserved.
//

#import "FunikiSDK.h"

/**
 * これは雰囲気メガネを簡単に光らせるためのサンプル・コードです。 SDKの全ての機能を使用するには、MAFunikiManagerを使用してください。
 * @see MAFunikiManager
 */
@interface Funiki : NSObject

/**
 *  雰囲気メガネのLEDの色を変更する。雰囲気メガネが接続されていない場合は、電波強度の強い雰囲気メガネに自動的に接続を試みる。接続が完了すると、LEDの色が指定した色に変化する。
 *
 *  @param color 色をUIColorで指定する。
 */
+ (void)changeColor:(UIColor *)color;

/**
 * このメソッドを呼び出すと、接続や色の変化が始まるまでの時間を短縮できる。このメソッドは必ずしも呼び出す必要はない。
 */
+ (void)prepare;
@end

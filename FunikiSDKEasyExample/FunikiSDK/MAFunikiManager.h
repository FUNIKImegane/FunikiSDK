//
//  MAFunikiManager.h
//  MAFunikiManager
//
//  Created by Matilde Inc.
//  Copyright (c) 2015 FUN'IKI Project. All rights reserved.
//

@import Foundation;
@import UIKit;
@import CoreBluetooth;

/**
 * ブザーの音量
 */
typedef NS_ENUM(NSUInteger, MAFunikiManagerBuzzerVolume) {
    MAFunikiManagerBuzzerVolumeMute,
    MAFunikiManagerBuzzerVolumeLow,
    MAFunikiManagerBuzzerVolumeMedium,
    MAFunikiManagerBuzzerVolumeLoud
};

/** 
 * ボタンのプッシュ・イベント
 */
typedef NS_ENUM(NSUInteger, MAFunikiManagerButtonEventType) {
    MAFunikiManagerButtonEventTypeUnknown,
    MAFunikiManagerButtonEventTypeSinglePush,
    MAFunikiManagerButtonEventTypeDoublePush,
};

/**
 * バッテリー・レベル
 */
typedef NS_ENUM(NSUInteger, MAFunikiManagerBatteryLevel) {
    MAFunikiManagerBatteryLevelUnknown,
    MAFunikiManagerBatteryLevelLow,
    MAFunikiManagerBatteryLevelMedium,
    MAFunikiManagerBatteryLevelHigh,
};

@class MAFunikiManager;

#import "MADiscoveredPeripheral.h"
#import "MAFunikiMotionData.h"

@protocol MAFunikiManagerDelegate <NSObject>
@optional
/**
 *  startSelectingDeviceを呼び出した後、発見した雰囲気メガネが配列 [MADiscoveredPeripheral] で渡される。
 *
 *  @param manager     メソッドの呼び出し元
 *  @param peripherals MADiscoveredPeripheralの配列。配列はrssi順にソートされている。ただし、すでにiOSと雰囲気メガネ間の接続が確立されている場合、rssiは0になる。
 */
- (void)funikiManager:(MAFunikiManager *)manager didUpdateDiscoveredPeripherals:(NSArray *)peripherals;

/**
 *  雰囲気メガネとアプリが通信可能になった時に呼び出される。
 *
 *  @param manager メソッドの呼び出し元
 */
- (void)funikiManagerDidConnect:(MAFunikiManager *)manager;

/**
 *  雰囲気メガネとアプリが通信できない状態になった時に呼び出される。
 *
 *  @param manager メソッドの呼び出し元
 *  @param error 接続がエラーによって切断された場合、内部のライブラリからエラーが渡される。
 */
- (void)funikiManagerDidDisconnect:(MAFunikiManager *)manager error:(NSError *)error;

/**
 *  CBCentralManagerの状態が変化した時に呼び出される。Bluetoothがオフのとき、利用不可能なときは、ユーザへ通知を推奨。
 *
 *  @param manager   メソッドの呼び出し元
 *  @param state CBCentralManagerの状態
 */
- (void)funikiManager:(MAFunikiManager *)manager didUpdateCentralState:(CBCentralManagerState)state;

/**
 *  雰囲気メガネのバッテリー・レベルを読み取った時に呼び出される。バッテリー・レベルの読み取りは自動的に行われる。
 *
 *  @param manager メソッドの呼び出し元
 *  @param batteryLevel バッテリー・レベル
 *  @see MAFunikiManagerBatteryLevel
 *
 */
- (void)funikiManager:(MAFunikiManager *)manager didUpdateBatteryLevel:(MAFunikiManagerBatteryLevel)batteryLevel;

@end

@protocol MAFunikiManagerDataDelegate <NSObject>
@optional

/**
 *  雰囲気メガネの加速度、角速度センサで値が更新されると呼び出される。
 *
 *  @param manager メソッドの呼び出し元
 *  @param motionData センサのデータ
 *  @see MAFunikiMotionData
 */
- (void)funikiManager:(MAFunikiManager *)manager didUpdateMotionData:(MAFunikiMotionData *)motionData;

/**
 *  雰囲気メガネのプッシュ・ボタンがプッシュ、ダブル・プッシュされた時に呼び出される。
 *
 *  @param manager メソッドの呼び出し元
 *  @param buttonEventType イベントの種類
 *  @see MAFunikiManagerButtonEventType
 */
- (void)funikiManager:(MAFunikiManager *)manager didPushButton:(MAFunikiManagerButtonEventType)buttonEventType;

@end

@interface MAFunikiManager : NSObject 
{
    
}
/**
 *  MAFunikiManagerで起きたイベントを受け取るdelegateを指定。
 */
@property (nonatomic, weak) id <MAFunikiManagerDelegate>delegate;

/**
 *  センサーのデータを受け取るDelegateを指定。
 */
@property (nonatomic, weak) id <MAFunikiManagerDataDelegate>dataDelegate;

/**
 *  雰囲気メガネが接続されているかどうかを返す。
 */
@property (nonatomic, readonly, getter = isConnected) BOOL connected;

/**
 *  前回接続した雰囲気メガネに自動接続できる状態かを返す。
 */
@property (nonatomic, readonly, getter=isAutoConnectEnabled) BOOL autoConnectEnabled;

/**
 *  CBCentralManagerの現在の状態を返す。
 */
@property (nonatomic, readonly) CBCentralManagerState centralManagerState;

/**
 *  発見した雰囲気メガネのリストを返す。MADiscoveredPeripheral 型のオブジェクトが入っている。Swiftで使用する場合は as [MADiscoveredPeripheral]でキャストする。
 */
@property (nonatomic, readonly) NSArray *discoveredPeripherals;

/**
 *  接続している雰囲気メガネにインストールされているファームウェアリビジョンを返す。接続ができていない場合、読み取りに失敗した時はnilを返すことがある。
 */
@property (nonatomic, readonly) NSNumber *firmwareRevision;

/**
 * 雰囲気メガネのバッテリー・レベルを返す。雰囲気メガネと接続できていない場合は、MAFunikiManagerBatteryLevelUnknownを返す。
 */
@property (nonatomic, readonly) MAFunikiManagerBatteryLevel batteryLevel;


/* Returns the default singleton instance.
 */
+ (instancetype)sharedInstance;

/**
 *  雰囲気メガネを探索/登録する。雰囲気メガネを発見すると、delegateのfunikiManager:didUpdateDiscoveredPeripherals:が呼び出される。このメソッドを呼び出すと、雰囲気メガネへの自動接続がキャンセルされる。
 */
- (void)startSelectingDevice;

/**
 *  雰囲気メガネの検索/登録を終了する。
 */
- (void)stopSelectingDevice;

/**
 *  雰囲気メガネに接続をする。一度接続をした雰囲気メガネは、以降MAFunikiManagerのインスタンスが生成された時から自動的に接続が行われる。
 *
 *  @param discoveredPeripheral 検索にて発見したPeripheralを指定する。CBPeripheralではない。
 */
- (void)connectPeripheral:(MADiscoveredPeripheral *)discoveredPeripheral;

/**
 *  LEDを点灯させる。
 *  @param color    左右のLEDの色
 */
- (void)changeColor:(UIColor *)color;

/**
 *  LEDを点灯させる。
 *
 *  @param leftColor  左のLEDの色
 *  @param rightColor 右のLEDの色
 *  @param duration   メガネの現在の状態からleftColor、rightColorに指定した色に遷移する時間を指定する。指定できる値は0.0...655.0(秒)。
 */
- (void)changeLeftColor:(UIColor *)leftColor rightColor:(UIColor *)rightColor duration:(NSTimeInterval)duration;

/**
 *  LEDを点灯させる。同時にブザーも指定した周波数で鳴らす。
 *
 *  @param leftColor  左のLEDの色
 *  @param rightColor 右のLEDの色
 *  @param duration   メガネの現在の状態からleftColor、rightColorに指定した色に遷移する時間を指定する。指定できる値は0.0...655.0(秒)。
 *  @param freq       ブザーの周波数を指定する。事前に -roundedBuzzerFrequency メソッドを使って出力可能な周波数を指定する。それ以外の周波数を指定した場合発音可能な周波数に丸められる。
 *  @param buzzerVolume        ブザーのボリューム
 *  @see roundedBuzzerFrequency:
 */
- (void)changeLeftColor:(UIColor *)leftColor rightColor:(UIColor *)rightColor duration:(NSTimeInterval)duration buzzerFrequency:(NSInteger)freq buzzerVolume:(MAFunikiManagerBuzzerVolume)volume;

/**
 *  発音可能な周波数に丸める。雰囲気メガネのブザーは離散的な周波数のみを鳴らすことができるので、指定した周波数に一番近い周波数に丸めて周波数を返す。
 *
 *  @param freq 指定する周波数
 *
 *  @return 発音可能な周波数
 */
- (NSInteger)roundedBuzzerFrequency:(NSInteger)freq;

/**
 *  6軸加速度/角速度センサを有効にして、値の受け取りを開始する。
 */
- (void)startMotionSensor;

/**
 *  6軸加速度/角速度センサを無効にして、値の受け取りを終了する。
 */
- (void)stopMotionSensor;

/**
 * SDKのバージョン番号を返す。
 */
+ (NSString *)funikiSDKVersionString;

@end

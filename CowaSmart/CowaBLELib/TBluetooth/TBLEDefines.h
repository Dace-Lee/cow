//
//  TBLEDefines.h
//  Cowa
//
//  Created by MX on 16/8/9.
//  Copyright © 2016年 MX. All rights reserved.
//

#ifndef TBLEDefines_h
#define TBLEDefines_h

#define ServiceUUID @"00000000-0000-1000-8000-00805F9B3400"
#define DATA_SEVICE @"00000000-0000-1000-8000-00805F9B3500"

#define CharacteristicUUIDNotify @"00000000-0000-1000-8000-00805F9B3401"
#define CharacteristicUUIDWrite @"00000000-0000-1000-8000-00805F9B3402"

#define dataCharacteristicUUIDNotify @"00000000-0000-1000-8000-00805F9B3502"
#define dataCharacteristicUUIDWrite @"00000000-0000-1000-8000-00805F9B3501"

#endif /* TBLEDefines_h */

///define block declare
#define weakify(var) __weak typeof(var) AHKWeak_##var = var;
#define strongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = AHKWeak_##var; \
_Pragma("clang diagnostic pop")

#define START @"434f"
#define END @"5741"

//用户相关指令
#define USER_GROUPID @"03"
#define USER_COMMANDID @"1D"
#define USER_MANAGERID_HOST @"01"
#define USER_MANAGERID_AUTH @"02"
#define USER_MANAGERID_IMEI @"03"
#define USER_MANAGERID_RESET @"04"
#define USER_MANAGERID_ADDUSER @"05"
#define USER_MANAGERID_DELUSER @"06"

//蓝牙应答command id
#define ACK_USER_COMMANDID @"45"
#define ACK_OPRATION_COMMANDID @"28"
#define ACK_HEARTBEAT_COMMANDID @"42"
#define ACK_VERSION_COMMANDID @"46"




//主锁
#define MAIN_LOCK_OPEN 1
#define MAIN_LOCK_CLOSE 2
//前锁
#define BEHIND_LOCK_OPEN 3
#define BEHIND_LOCK_CLOSE 4
//逆时针转
#define ANTICLOCK_WISE_OPEN 5
#define ANTICLOCK_WISE_CLOSE 6
//顺时针转
#define CLOCK_WISE_OPEN 7
#define CLOCK_WISE_CLOSE 8
//避障
#define AVOID_HAZARD_OPEN 9
#define AVOID_HAZARD_CLOSE 10
//手动
#define MANNAL_OPEN 11
#define MANNAL_CLOSE 12
//轮子升降
#define WHEEL_UP 13
#define WHEEL_DOWN 14
//WiFi开关
#define WIFI_OPEN 15
#define WIFI_CLOSE 16
//使能控制
#define ENABLE_OPEN 17
#define ENABLE_CLOSE 18
//急停
#define ABRUP_STOP_OPEN 19
#define ABRUP_STOP_CLOSE 20
//速度指令
#define MOVE_CMD 21
//速度设置指令
#define SPEED_SET 22
//主锁呼吸灯
#define LAMP_SET_CLOSE 23
#define LAMP_SET_RED 24
#define LAMP_SET_GREEN 25
#define LAMP_SET_BLUE 26
//wifi连接
#define WIFI_CONNECT_SSID 27
#define WIFI_CONNECT_PWD 28
//Find Me
#define FIND_ME_OPEN 29
#define FIND_ME_CLOSE 30





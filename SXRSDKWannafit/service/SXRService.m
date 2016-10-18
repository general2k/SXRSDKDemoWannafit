//
//  SXRService.m
//  SXRSDKDemo4Goband
//
//  Created by qf on 16/10/10.
//  Copyright © 2016年 Keeprapid. All rights reserved.
//

#import "SXRService.h"
#import <SXRSDK/SXRSDK.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface SXRService()
@end

@implementation SXRService
+(SXRService *)SharedInstance
{
    static SXRService *service = nil;
    if (service == nil) {
        service = [[SXRService alloc] init];
    }
    return service;
}

-(id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
#define GEAR_BLE_NAME_S1 @"WannaFit-T1D"
#define GEAR_BLE_NAME_S3 @"WannaFit-T3D"
#define GEAR_BLE_NAME_S9 @"WannaFit-T9D"
#define GEAR_BLE_NAME_S10 @"WannaFit-T10D"
#define GEAR_BLE_NAME_F1 @"WannaFit-G1D"
#define GEAR_BLE_NAME_U9 @"WannaFit-U9D"
#define GEAR_BLE_NAME_X6 @"iiwatch-X6"
+(void)InitSXRSDK{
    [SXR initializeWithProtocolType:SXRSDKProtoclType_Wannafit andAppID:DEMO_APPID andSecret:DEMO_SECRET andVid:DEMO_VID];
    NSLog(@"%d",[SXR shareInstance].protocolType);
    [SXR shareInstance].bleNameFilter = ^(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI){
        NSLog(@"sxrblenamefilter, %@",peripheral.name);
        if ([peripheral.name hasPrefix:GEAR_BLE_NAME_S1]||
            [peripheral.name hasPrefix:GEAR_BLE_NAME_S3]||
            [peripheral.name hasPrefix:GEAR_BLE_NAME_S9]||
            [peripheral.name hasPrefix:GEAR_BLE_NAME_S10]||
            [peripheral.name hasPrefix:GEAR_BLE_NAME_F1]||
            [peripheral.name hasPrefix:GEAR_BLE_NAME_U9]||
            [peripheral.name hasPrefix:GEAR_BLE_NAME_X6]) {
            return YES;
        }
        return NO;
    };
    [SXR shareInstance].deviceReady = testDeviceReady;
    
    
    
}
void testDeviceReady(){
    NSLog(@"testDeviceReady");
    NSMutableDictionary* bi = [SXRSDKUtils getDeviceInformation:[SXRSDKConfig getCurrentDeviceUUID]];
    NSString* macid = @"";
    if (bi){
        NSString* tmpid = [bi objectForKey:BONGINFO_KEY_BLEADDR];
        if(tmpid && ![tmpid isEqualToString:@""]){
            macid = tmpid;
        }
    }
    if ([macid isEqualToString:@""]) {
        [[SXR shareInstance] AddCommand:CMD_JY_GETMAC withParam:nil toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    }
    [[SXR shareInstance] AddCommand:CMD_JY_GETFW withParam:nil toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    [[SXR shareInstance] AddCommand:CMD_JY_READTIME withParam:nil toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    [[SXR shareInstance] AddCommand:CMD_JY_SETPARAM withParam:nil toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
 

}


+(void)GetHistoryData:(NSDictionary*)paramlist{
    if ([[SXR shareInstance] isConnect]) {
        [[SXR shareInstance] AddCommand:CMD_JY_SYNCDATA withParam:nil toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    }

}
+(void)SetPersonInfo:(NSDictionary*)paramlist{
    if ([[SXR shareInstance] isConnect]) {
        [[SXR shareInstance] AddCommand:CMD_JY_SETPERSON withParam:paramlist toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    }
 
}

+(void)SetDeviceParam:(NSDictionary*)paramlist{
    if ([[SXR shareInstance] isConnect]) {
        [[SXR shareInstance] AddCommand:CMD_JY_SETPARAM withParam:paramlist toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    }
    
}
+(void)ReadTime:(NSDictionary*)paramlist{
    if ([[SXR shareInstance] isConnect]) {
        [[SXR shareInstance] AddCommand:CMD_JY_READTIME withParam:paramlist toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    }
    
}
+(void)SetTime:(NSDictionary*)paramlist{
    if ([[SXR shareInstance] isConnect]) {
        [[SXR shareInstance] AddCommand:CMD_JY_SETTIME withParam:paramlist toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    }
    
}


+(void)ReadFirmware:(NSDictionary*)paramlist{
    if ([[SXR shareInstance] isConnect]) {
        [[SXR shareInstance] AddCommand:CMD_JY_GETFW withParam:paramlist toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    }
 
}
+(void)ReadMacID:(NSDictionary*)paramlist{
    if ([[SXR shareInstance] isConnect]) {
        [[SXR shareInstance] AddCommand:CMD_JY_GETMAC withParam:paramlist toCharacteristicKey:nil HighPriority:NO waitResponse:YES];
    }
  
}

@end

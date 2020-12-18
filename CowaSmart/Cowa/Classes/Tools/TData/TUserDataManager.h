//
//  TUserDataManager.h
//  Cowa
//
//  Created by MX on 16/5/30.
//  Copyright © 2016年 MX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUserDataManager.h"

@interface MUserData : NSObject
@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *pwd;

@property (nonatomic ,strong) NSString *loginToken;

@property (nonatomic ,strong ,readonly) NSDate *updateDate;
- (void)refreshUpdateDate;
@end


@interface TUserDataManager : NSObject
@property (nonatomic ,strong ,readonly) MUserData *data;
+ (instancetype)sharedDataMananer;

- (void)updateLocalData:(MUserData *)model;
@end

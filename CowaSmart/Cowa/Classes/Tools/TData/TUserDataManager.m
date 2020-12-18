//
//  TUserDataManager.m
//  Cowa
//
//  Created by MX on 16/5/30.
//  Copyright © 2016年 MX. All rights reserved.
//

#import "TUserDataManager.h"
#import <objc/runtime.h>

@implementation MUserData
- (void)refreshUpdateDate {
    _updateDate = [NSDate date];
}

@end

@implementation TUserDataManager
@synthesize data = _data;

+ (instancetype)sharedDataMananer {
    static id shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[[self class] alloc] init];
    });
    return shared;
}

- (id)init {
    if (self = [super init]) {
        [self changeObserverStatus:YES];
    }
    return self;
}

- (void)dealloc {
    [self changeObserverStatus:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([object isEqual:self.data]) {
        if ([change.allKeys containsObject:@"new"]) {
            [self updateLocalData:_data];
        }
    }
}

- (void)updateLocalData:(MUserData *)model {
    _data = model;
    [_data refreshUpdateDate];
    NSDictionary *dic = [self dicMappingKey:[model class]];
    for (int i = 0; i < dic.allKeys.count; i ++) {
        NSString *key = dic.allKeys[i];
        NSString *name = [dic valueForKey:key];
        id data = [model valueForKeyPath:name];
        [self updateProperty:key value:data];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (MUserData *)data {
    if (!_data) {
        _data = [[MUserData alloc] init];
        NSDictionary *dic = [self dicMappingKey:[_data class]];
        for (int i = 0; i < dic.allKeys.count; i ++) {
            NSString *key = dic.allKeys[i];
            NSString *name = [dic valueForKey:key];
            NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
            id value = nil;
            @try {
                value = [de valueForKey:key];
            } @catch (NSException *exception) {
                //DLog(@"%@",exception);
            } @finally {
                
            }
            [_data setValue:value forKeyPath:name];
        }
    }
    return _data;
}

- (void)updateProperty:(NSString *)key value:(id)value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
}

- (NSMutableDictionary <NSString *,NSString *>*)dicMappingKey:(Class)objClass {
    NSMutableDictionary <NSString *,NSString *> *dic = [[NSMutableDictionary alloc] init];
    NSString *prefix = @"UserData_";
    
    unsigned int propertyCount;
    objc_property_t *propertys = class_copyPropertyList(objClass, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i ++) {
        objc_property_t property = propertys[i];
        const char *pname = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:pname];
        NSString *key = [prefix stringByAppendingString:name];
        
        [dic setValue:name forKey:key];
    }
    return dic;
}

- (void)changeObserverStatus:(BOOL)isObserver {
    NSDictionary *dic = [self dicMappingKey:[MUserData class]];
    for (NSString *name in dic.allValues) {
        if (isObserver) {
            [self.data addObserver:self forKeyPath:name options:NSKeyValueObservingOptionNew context:nil];
        } else {
            [self.data removeObserver:self forKeyPath:name];
        }
    }
}

@end

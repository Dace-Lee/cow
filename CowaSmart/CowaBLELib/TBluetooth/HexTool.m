//
//  HexTool.m
//  CowaBLE
//
//  Created by gaojun on 2017/9/13.
//  Copyright © 2017年 mx. All rights reserved.
//

#import "HexTool.h"
#import "FFTool.h"

@implementation HexTool
+(NSString *)create32HexStartWith80:(NSString *)str
{
    //字符串补0
    NSMutableString *buquanStr = [NSMutableString stringWithFormat:@"00000000%@",str];
    NSMutableString *hexString = [NSMutableString string];
    NSUInteger length = buquanStr.length;
    for (long i=length-8;i<=length-1;i++){
        unichar c = [buquanStr characterAtIndex:i];
        [hexString appendString:[NSString stringWithFormat:@"%c",c]];
    }
    //字符串截取
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0;i<=6;i=i+2){
        NSString *str = [hexString substringWithRange:NSMakeRange(i, 2)];
        [array addObject:str];
    }
    //数组元素翻转
    NSMutableArray *array2 =[NSMutableArray array];
    for(int i=3;i>=0;i--){
        [array2 addObject:array[i]];
    }
    [array2 replaceObjectAtIndex:3 withObject:@"80"];
    //数组转为字符串
    NSString *seqStr =[FFTool arrayChangeToString:array2 withSplit:@","];
    return seqStr;
}

+(NSString *)create32Hex:(NSString *)str
{
    //字符串补0
    NSMutableString *buquanStr2 = [NSMutableString stringWithFormat:@"00000000%@",str];
    NSMutableString *hexString2 = [NSMutableString string];
    NSUInteger length2 = buquanStr2.length;
    for (long i=length2-8;i<=length2-1;i++){
        unichar c = [buquanStr2 characterAtIndex:i];
        [hexString2 appendString:[NSString stringWithFormat:@"%c",c]];
    }
    //字符串截取
    NSMutableArray *array3 = [NSMutableArray array];
    for (int i=0;i<=6;i=i+2){
        NSString *str = [hexString2 substringWithRange:NSMakeRange(i, 2)];
        [array3 addObject:str];
    }
    //数组元素翻转
    NSMutableArray *array4 =[NSMutableArray array];
    for(int i=3;i>=0;i--){
        [array4 addObject:array3[i]];
    }
    //数组转为字符串
    NSString *sizeStr =[FFTool arrayChangeToString:array4 withSplit:@","];
    return sizeStr;
}

+(NSString *)create16Hex:(NSString *)str
{
    //字符串补0
    NSMutableString *buquanStrX = [NSMutableString stringWithFormat:@"0000%@",str];
    NSMutableString *hexStringX = [NSMutableString string];
    NSUInteger lengthX = buquanStrX.length;
    for (long i=lengthX-4;i<=lengthX-1;i++){
        unichar c = [buquanStrX characterAtIndex:i];
        [hexStringX appendString:[NSString stringWithFormat:@"%c",c]];
    }
    //字符串截取
    NSMutableArray *arrayX = [NSMutableArray array];
    for (int i=0;i<=2;i=i+2){
        NSString *strX = [hexStringX substringWithRange:NSMakeRange(i, 2)];
        [arrayX addObject:strX];
    }
    //数组元素翻转
    NSMutableArray *array2X =[NSMutableArray array];
    for(int i=1;i>=0;i--){
        [array2X addObject:arrayX[i]];
    }
    //数组转为字符串
    NSString *seqStr =[FFTool arrayChangeToString:array2X withSplit:@","];
    return seqStr;
}


@end

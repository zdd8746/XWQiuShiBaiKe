//
//  Toolkit.h
//  XWQSBK
//
//  Created by renxinwei on 13-4-30.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiuShiImageViewController.h"
#import "QiuShiDetailViewController.h"
#import "XWSliderSwitch.h"
#import "QiuShiCell.h"
#import "QiuShi.h"
#import "QBUser.h"

typedef enum {
    QiuShiTypeSuggest   = 1000,       //随便逛逛-干货
    QiuShiTypeLatest    = 1001,       //随便逛逛-嫩草
    QiuShiTypeDay       = 2000,       //精华-日
    QiuShiTypeWeek      = 2001,       //精华-周
    QiuShiTypeMonth     = 2002,       //精华-月
    QiuShiTypeImgrank   = 3000,       //有图有真相-硬菜
    QiuShiTypeImages    = 3001,       //有图有真相-时令
    QiuShiTypeHistory   = 4000        //穿越
}QiuShiType;

typedef enum {
    NeiHanTypePic       = 5000,       //内涵-囧图
    NeiHanTypeGirl      = 5001,       //内涵-女照
    NeiHanTypeVideo     = 6000        //内涵-视频
}NeiHanType;

@interface Toolkit : NSObject

+ (BOOL)isExistenceNetwork;
+ (void)saveQBTokenLocal:(NSString *)token;
+ (NSString *)getQBTokenLocal;
+ (void)saveQBUserLocal:(QBUser *)qbUser;
+ (QBUser *)getQBUserLocal;
+ (UIColor *)getAppBackgroundColor;
+ (NSString *)dateStringAfterRandomDay;

@end

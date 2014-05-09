//
//  Config.m
//  XWQiuShiBaiKe
//
//  Created by Ren XinWei on 13-5-27.
//  Copyright (c) 2013年 renxinwei's iMac. All rights reserved.
//

#import "Config.h"

@implementation Config

static Config *instance = nil;

+ (Config *)Instance
{
    @synchronized(self)
    {
        if (instance == nil) {
            [self new];
        }
    }
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

@end

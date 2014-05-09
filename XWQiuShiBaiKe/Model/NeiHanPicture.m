//
//  NeiHanPicture.m
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-6-15.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import "NeiHanPicture.h"

@implementation NeiHanPicture

- (id)initWithNeiHanPictureDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.wid = [dictionary objectForKey:@"wid"];
        self.wbody = [dictionary objectForKey:@"wbody"];
        self.update_time = [dictionary objectForKey:@"update_time"];
        self.wpic_small = [dictionary objectForKey:@"wpic_small"];
        self.wpic_middle = [dictionary objectForKey:@"wpic_middle"];
        self.wpic_large = [dictionary objectForKey:@"wpic_large"];
        self.wpic_s_width = [dictionary objectForKey:@"wpic_s_width"];
        self.wpic_s_height = [dictionary objectForKey:@"wpic_s_height"];
        self.wpic_m_width = [dictionary objectForKey:@"wpic_m_width"];
        self.wpic_m_height = [dictionary objectForKey:@"wpic_m_height"];
        self.is_gif = [dictionary objectForKey:@"is_gif"];
    }
    return self;
}

- (void)dealloc
{
    _wid = nil;
    _wbody = nil;
    _update_time = nil;
    _wpic_small = nil;
    _wpic_middle = nil;
    _wpic_large = nil;
    _wpic_s_width = nil;
    _wpic_s_height = nil;
    _wpic_m_width = nil;
    _wpic_m_height = nil;
    _is_gif = nil;
    
    [super dealloc];
}

@end

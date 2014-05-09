//
//  NeiHanVideo.m
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-6-15.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import "NeiHanVideo.h"

@implementation NeiHanVideo

- (id)initWithNeiHanVideoDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.wid = [dictionary objectForKey:@"wid"];
        self.wbody = [dictionary objectForKey:@"wbody"];
        self.vpic_small = [dictionary objectForKey:@"vpic_small"];
        self.vpic_middle = [dictionary objectForKey:@"vpic_middle"];
        self.vtitle = [dictionary objectForKey:@"vtitle"];
        self.vplay_url = [dictionary objectForKey:@"vplay_url"];
        self.vsource_url = [dictionary objectForKey:@"vsource_url"];
        self.update_time = [dictionary objectForKey:@"update_time"];
    }
    return self;
}

- (void)dealloc
{
    _wid = nil;
    _wbody = nil;
    _vpic_small = nil;
    _vpic_middle = nil;
    _vtitle = nil;
    _vplay_url = nil;
    _vsource_url = nil;
    _update_time = nil;
    
    [super dealloc];
}
@end

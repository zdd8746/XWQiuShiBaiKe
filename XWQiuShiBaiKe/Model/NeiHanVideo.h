//
//  NeiHanVideo.h
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-6-15.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeiHanVideo : NSObject

@property (nonatomic, copy) NSString *wid;
@property (nonatomic, copy) NSString *wbody;
@property (nonatomic, copy) NSString *vpic_small;
@property (nonatomic, copy) NSString *vpic_middle;
@property (nonatomic, copy) NSString *vtitle;
@property (nonatomic, copy) NSString *vplay_url;
@property (nonatomic, copy) NSString *vsource_url;
@property (nonatomic, copy) NSString *update_time;

- (id)initWithNeiHanVideoDictionary:(NSDictionary *)dictionary;

@end

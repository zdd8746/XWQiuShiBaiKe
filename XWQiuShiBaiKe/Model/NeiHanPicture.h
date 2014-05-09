//
//  NeiHanPicture.h
//  XWQiuShiBaiKe
//
//  Created by renxinwei on 13-6-15.
//  Copyright (c) 2013年 renxinwei's MacBook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeiHanPicture : NSObject

@property (nonatomic, copy) NSString *wid;                      //图片id
@property (nonatomic, copy) NSString *wbody;                    //图片内容
@property (nonatomic, copy) NSString *update_time;              //更新时间
@property (nonatomic, copy) NSString *wpic_small;               //小图
@property (nonatomic, copy) NSString *wpic_middle;              //中图
@property (nonatomic, copy) NSString *wpic_large;               //大图
@property (nonatomic, copy) NSString *wpic_s_width;             //小图 宽
@property (nonatomic, copy) NSString *wpic_s_height;            //小图 高
@property (nonatomic, copy) NSString *wpic_m_width;             //中图 宽
@property (nonatomic, copy) NSString *wpic_m_height;            //中图 高
@property (nonatomic, copy) NSString *is_gif;                   //是否gif图

- (id)initWithNeiHanPictureDictionary:(NSDictionary *)dictionary;

@end

//
//  MessageModel.h
//  AmazonawsDemo
//
//  Created by qingsong on 2020/4/12.
//  Copyright © 2020 qingsong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageItemModel : NSObject

@property (nonatomic, copy) NSString *content; // content 文本
@property (nonatomic, copy) NSString *userID; // 用户ID
@property (nonatomic, copy) NSString *creationTimeString; // 发送时间

@property (nonatomic, assign) NSTimeInterval creationTime;
@end


@interface MessageModel : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSArray <MessageItemModel *> *items;
@property (nonatomic, strong) MessageItemModel *lastItem;
@end


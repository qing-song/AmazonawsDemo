//
//  MessageTableViewCell.h
//  AmazonawsDemo
//
//  Created by qingsong on 2020/4/12.
//  Copyright © 2020 qingsong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MessageItemModel;
@interface MessageTableViewCell : UITableViewCell

@property (nonatomic, strong) MessageItemModel *messageItemModel;
@end

NS_ASSUME_NONNULL_END

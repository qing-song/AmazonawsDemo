//
//  MessageTableViewCell.m
//  AmazonawsDemo
//
//  Created by qingsong on 2020/4/12.
//  Copyright © 2020 qingsong. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "MessageModel.h"

@interface MessageTableViewCell ()

/// 消息内容
@property (weak, nonatomic) IBOutlet UILabel *msgDetailLabel;

/// 消息时间
@property (weak, nonatomic) IBOutlet UILabel *msgTimeLabel;

@end

@implementation MessageTableViewCell

- (void)setMessageItemModel:(MessageItemModel *)messageItemModel {
    _messageItemModel = messageItemModel;
    
    self.msgDetailLabel.text = _messageItemModel.content;
    self.msgTimeLabel.text = messageItemModel.creationTimeString;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

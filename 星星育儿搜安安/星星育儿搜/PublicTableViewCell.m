//
//  PublicTableViewCell.m
//  星星育儿搜
//
//  Created by qingyun on 15/9/17.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//

#import "PublicTableViewCell.h"
#import "PublicModel.h"
#import "UIImageView+WebCache.h"

@implementation PublicTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)GetFromTableViewModel:(PublicModel *)publicModel
{
    self.msgid = publicModel.msgid;
    self.title.text = publicModel.title;
    self.detail.text = publicModel.descrip;
    NSString *url = publicModel.images[0];
    NSString *urlstring= [url stringByAppendingString:@"_middle.jpg"];
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:urlstring]];
    
}

@end

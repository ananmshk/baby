//
//  CollectionViewCell.m
//  星星育儿搜
//
//  Created by qingyun on 15/9/17.
//  Copyright (c) 2015年 河南青云信息科技有限公司. All rights reserved.
//

#import "CollectionViewCell.h"
#import "HotLabel.h"
@implementation CollectionViewCell

- (void)didMoveToSuperview
{
    self.title.layer.cornerRadius = self.frame.size.width/2;
    self.layer.masksToBounds = YES;
    //    self.layer.backgroundColor = [self randomColor].CGColor;
    self.title.backgroundColor = [self randomColor];
}

- (UIColor *)randomColor
{
    UIColor *color = [UIColor colorWithRed:( arc4random() % 256 / 256.0 )green:( arc4random() % 256 / 256.0 )  blue:( arc4random() % 256 / 256.0 )alpha:.8f];
    return color;
}

- (void)setCollectionCellWithModel:(HotLabel *)model
{
    [self.title setTitle:model.labelname forState:UIControlStateNormal];
    self.labelID = model.labelid;
    
}

@end

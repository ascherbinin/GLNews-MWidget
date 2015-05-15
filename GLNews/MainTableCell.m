//
//  MainTableViewCell.m
//  GLNews
//
//  Created by Admin on 06.05.15.
//  Copyright (c) 2015 GoodLine. All rights reserved.
//

#import "MainTableCell.h"

@implementation MainTableCell

@synthesize imageNews;
@synthesize titleNews;
@synthesize descriptionNews;
@synthesize dateNews;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

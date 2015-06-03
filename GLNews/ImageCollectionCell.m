//
//  ImageCollectionCell.m
//  GLNews
//
//  Created by Андрей Щербинин on 02.06.15.
//  Copyright (c) 2015 GoodLine. All rights reserved.
//

#import "ImageCollectionCell.h"

@implementation ImageCollectionCell 

- (void)awakeFromNib {
    // Initialization code
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView 
{
    return self.imageView;
}

@end

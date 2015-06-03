//
//  ImageCollectionCell.h
//  GLNews
//
//  Created by Андрей Щербинин on 02.06.15.
//  Copyright (c) 2015 GoodLine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionCell : UICollectionViewCell<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

//
//  TodayViewController.h
//  GLNews Widget
//
//  Created by Андрей Щербинин on 14.05.15.
//  Copyright (c) 2015 GoodLine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayWidgetViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;


@property (strong, nonatomic) NSMutableArray *objects;

@end

//
//  DetailViewController.h
//  GLNews
//
//  Created by Admin on 07.05.15.
//  Copyright (c) 2015 GoodLine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsElement.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UITextView *textView;


@property (nonatomic,strong) NewsElement *newsElementDetail;

-(void) setDetails:(NewsElement*)newsElementDetail;


@end

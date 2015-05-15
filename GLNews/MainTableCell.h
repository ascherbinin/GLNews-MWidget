//
//  MainTableViewCell.h
//  GLNews
//
//  Created by Admin on 06.05.15.
//  Copyright (c) 2015 GoodLine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageNews;
@property (strong, retain) IBOutlet UILabel *titleNews;
@property (strong, retain) IBOutlet UILabel *descriptionNews;
@property (strong, retain) IBOutlet UILabel *dateNews;

@end

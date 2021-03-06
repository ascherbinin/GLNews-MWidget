//
//  MainViewController.h
//  GLNews
//
//  Created by Admin on 06.05.15.
//  Copyright (c) 2015 GoodLine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "NewsElement.h"

@interface MainViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>


@property (retain, nonatomic) DetailViewController *detailViewController;
@property (nonatomic, strong) NewsElement *newsElement;

@property (strong, nonatomic) NSMutableArray *objects;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *loadingView;

@property int pageNumber;

-(void)loadLastNewsForWidget;

@end

//
//  TodayViewController.m
//  GLNews Widget
//
//  Created by Андрей Щербинин on 14.05.15.
//  Copyright (c) 2015 GoodLine. All rights reserved.
//

#import "TodayWidgetViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "NewsElement.h"
#import "TFHpple.h"
#import "RDHelper.h"


@interface TodayWidgetViewController () <NCWidgetProviding>

@end

@implementation TodayWidgetViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(200, 75);

  
    [self loadView];
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    NSString *urlString = [NSString stringWithFormat:@"AppUrlType://home/"];
    NSURL *pjURL = [NSURL URLWithString:urlString];
    [self.extensionContext openURL:pjURL completionHandler:nil];
}

-(void)loadView
{
    [super loadView];
    
    
    [self loadNews];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    
    [self.view addGestureRecognizer:singleFingerTap];
    
}

-(void)loadNews
{
    
    NSURL *newsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://live.goodline.info/guest/page%d",1]];
    
    
    NSArray *newsNodes = [RDHelper requestData:newsUrl xPathQueryStr:@"//article"];

    
    
    for (NSMutableArray *arr in [RDHelper parsArray:newsNodes]) {
        //Добавлением в основной массив _objects, полученных из запроса элементов с помощью хелпера RDHelper.
        [_objects addObject:arr];
        
        if([_objects count]==1)
            break;
    }

    
    if ([_objects count] == 0)
        NSLog(@"Нет загруженной последней новости");
    else
    {
        NewsElement *news = [_objects objectAtIndex:0];
        NSArray* images = [news imagesFromContent:news.imageUrl];
        NSString *imageStringURL = [images objectAtIndex:0];
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStringURL]];

        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 75, 75)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setBackgroundColor:[UIColor whiteColor]];
        
        if(imageStringURL == nil)
        {
            UIImage *image =[UIImage imageNamed:@"glnews.png"];
            [imageView setImage: image];
        }
        else
        {
            [imageView setImage: [UIImage imageWithData:data]];
        }

        
        [self.view addSubview:imageView];
        
        
       
        
       
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 175, 40)];
        
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
        titleLabel.numberOfLines =2;
        titleLabel.text = news.titleText;
        
        [self.view addSubview:titleLabel];
        
        UILabel *descriprionLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,15, 150, 65)];
        
        
        [descriprionLabel setTextColor:[UIColor lightGrayColor]];
        [descriprionLabel setBackgroundColor:[UIColor clearColor]];
        [descriprionLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 12.0f]];
        descriprionLabel.numberOfLines =0;
        descriprionLabel.text = news.dateNewsText;
        [self.view addSubview:descriprionLabel];

        
        
       
        
    }
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _objects = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {


    completionHandler(NCUpdateResultNewData);
}

@end

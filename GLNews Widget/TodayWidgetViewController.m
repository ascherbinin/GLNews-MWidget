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
    self.preferredContentSize = CGSizeMake(150, 75);
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    
    [self.view addGestureRecognizer:singleFingerTap];
    
}

-(void)loadNews
{
    
    NSURL *newsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://live.goodline.info/guest/page%d",1]];
    
    
    NSArray *newsNodes = [RDHelper requestData:newsUrl xPathQueryStr:@"//article"];
    
    
    if ([newsNodes count] == 0)
        NSLog(@"Нету node");
    else
    {
        NSLog(@"Найдено %lu корневых элементов", (unsigned long)[newsNodes count]);
        
        for (TFHppleElement *element in newsNodes){
            
            
            
            
            NewsElement *ne = [[NewsElement alloc]init];
            
            
            
            TFHppleElement *subelement = [element firstChildWithClassName:@"wraps out-topic"];
            TFHppleElement *descriptionElement = [subelement firstChildWithClassName:@"topic-content text"];
            TFHppleElement *titleElement =[subelement firstChildWithClassName:@"topic-header"] ;
            TFHppleElement *imageElement = [element firstChildWithClassName:@"preview"];
            
            ne.titleText =[[[titleElement firstChildWithClassName:@"topic-title word-wrap"] content]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            ne.descriptionText =[[descriptionElement content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *dateString = [[[titleElement firstChildWithTagName:@"time"]content]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            ne.dateNewsText = dateString;
            
            TFHppleElement *imageNode = [[imageElement firstChildWithTagName:@"a"] firstChildWithTagName:@"img"];
            
            ne.imageUrl = [imageNode objectForKey:@"src"];
            
            
            
            NSString *urlString = [[[titleElement firstChildWithTagName:@"h2"]firstChildWithTagName:@"a"] objectForKey:@"href"];
            ne.articleUrl =[NSURL URLWithString:urlString];
            
            
            [_objects addObject:ne];
        }
        
        NewsElement *news = [_objects objectAtIndex:0];
        NSArray* images = [news imagesFromContent:news.imageUrl];
        NSString *imageStringURL = [images objectAtIndex:0];
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStringURL]];

        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 75, 75)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];

        
        if(imageStringURL == nil)
        {
            UIImage *image =[UIImage imageNamed:@"glnews.png"];
            [imageView setImage: image];
        }
        else
        {
            [imageView setImage: [UIImage imageWithData:data]];
        }

        [imageView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:imageView];
        
        
       
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 150, 30)];
        
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont fontWithName: @"Trebuchet MS-Bold" size: 10.0f]];
        titleLabel.numberOfLines =1;
        [titleLabel setText:[NSString stringWithString:news.dateNewsText]];
        [self.view addSubview:titleLabel];
        
        UILabel *descriprionLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,25, 150, 60)];
        
        
        [descriprionLabel setTextColor:[UIColor lightGrayColor]];
        [descriprionLabel setBackgroundColor:[UIColor clearColor]];
        [descriprionLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 15.0f]];
        descriprionLabel.numberOfLines =0;
        [descriprionLabel setText:[NSString stringWithString:news.titleText]];
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
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end

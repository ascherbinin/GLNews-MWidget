//
//  DetailViewController.m
//  GLNews
//
//  Created by Admin on 07.05.15.
//  Copyright (c) 2015 GoodLine. All rights reserved.
//

#import "DetailViewController.h"
#import "NewsElement.h"
#import "ImageCollectionViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TFHpple.h"
#import "RDHelper.h"

@interface DetailViewController ()  <UIActionSheetDelegate>
@property NSArray* imageArray;
@end

@implementation DetailViewController
@synthesize imageView;
@synthesize contentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openNews)];
    self.navigationItem.rightBarButtonItem = item;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapGesture:)];
    [imageView addGestureRecognizer:tapGesture];
    
    [self reloadData];
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void) setDetails:(NewsElement*)reciveDetail;
{
    _newsElementDetail = reciveDetail;
}

- (void)imageViewTapGesture: (UITapGestureRecognizer *) gestureRecognizer
{
    
    ImageCollectionViewController* imageCollectionVC = [[ImageCollectionViewController alloc] initWithArray:_imageArray];
 
    [self.navigationController pushViewController:imageCollectionVC animated:YES];
}


-(void)openNews
{
   
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Назад" destructiveButtonTitle:nil otherButtonTitles:@"Открыть в браузере", nil];
    
    [actionSheet showInView:self.view];
}

-(void)openGallery
{
    
    ImageCollectionViewController *imgCV = [[ImageCollectionViewController alloc]init];
    [self.navigationController pushViewController:imgCV animated:YES];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [[UIApplication sharedApplication] openURL:_newsElementDetail.articleUrl];
            break;
        default:
            break;
    }
}

-(void) reloadData
{
    if(!_newsElementDetail)
    {
        NSLog(@"Пустой newsElement, в reload data(DetailViewController)");
        return;
    }
    
  
       NSArray *articleNodes = [RDHelper requestData:_newsElementDetail.articleUrl xPathQueryStr:@"//div[@class='topic-content text']"];
    //NSLog(@"%@",[[(TFHppleElement*)articleNodes objectAtIndex:1]content];
        self.navigationItem.title = _newsElementDetail.dateNewsText;
        self.titleLable.text = _newsElementDetail.titleText;

        
        
        for (TFHppleElement *element in articleNodes)
        {
            
            self.textView.text = [[element content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
        }
        
        if(_newsElementDetail.imageUrl != nil)
        {
            TFHppleElement *tempElement = [articleNodes objectAtIndex:0];
             _imageArray = [_newsElementDetail imagesFromContent:[tempElement raw]];
            NSString *imageStringURL = [_imageArray objectAtIndex:0];
            NSURL* imageURL = [NSURL URLWithString: imageStringURL];
            [self.imageView setImageWithURL: imageURL];
        }
        else
        {
            self.imageView.image = [UIImage imageNamed:@"glnews.png"];
        }
   
    
    NSLog(@"%@",_newsElementDetail.imageUrl);
}




@end

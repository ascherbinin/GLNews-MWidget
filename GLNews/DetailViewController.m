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
@synthesize galleryCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //Создание кнопки в navigation bar для открытия новости в браузере
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openNews)];
    self.navigationItem.rightBarButtonItem = item;
    
    //Создание и инициализация менеджера тапо по изображению, для перехода по тапу в галлерею
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapGesture:)];
    [imageView addGestureRecognizer:tapGesture];
    
    [self reloadData]; //Загрузка всех основных данных
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//Метод связка для передачи в detail controller данных по выбранной новости из main controller
-(void) setDetails:(NewsElement*)reciveDetail;
{
    _newsElementDetail = reciveDetail;
}

//Метод для обработки тапа по картинке внутри новости
- (void)imageViewTapGesture: (UITapGestureRecognizer *) gestureRecognizer
{
    if([_imageArray count]!=0)
    {
    //Инициализация коллекции с передачей в нее массива с фотографиями
        _imageVC = nil;
    _imageVC = [[ImageCollectionViewController alloc] initWithArray:_imageArray];
 
    [self.navigationController pushViewController:_imageVC animated:YES];
    }
}

//Метод открытия новости в браузере
-(void)openNews
{
   
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Назад" destructiveButtonTitle:nil otherButtonTitles:@"Открыть в браузере", nil];
    
    [actionSheet showInView:self.view];
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


//Загрука дополнительных данных для отображения полной новости.
-(void) reloadData
{
    if(!_newsElementDetail)
    {
        NSLog(@"Пустой newsElement, в reload data(DetailViewController)");
        return;
    }
    
    //Установка основных элементов detail controller
  
       NSArray *articleNodes = [RDHelper requestData:_newsElementDetail.articleUrl xPathQueryStr:@"//div[@class='topic-content text']"];
    
        self.navigationItem.title = _newsElementDetail.dateNewsText;
        self.titleLable.text = _newsElementDetail.titleText;

     //Загрузка текста описания
        
        for (TFHppleElement *element in articleNodes)
        {
            
            self.textView.text = [[element content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
        }
    
    //Работа с изображением
    
        if(_newsElementDetail.imageUrl != nil)
        {
            TFHppleElement *tempElement = [articleNodes objectAtIndex:0];
             _imageArray = [_newsElementDetail imagesFromContent:[tempElement raw]];
            
            if ([_imageArray count] >0) {
                //Отображение количества фотографий в галлереии к данной новости.
                self.galleryCount.text = [NSString stringWithFormat:@"Фото: %lu",(unsigned long)[_imageArray count]];
                
                [self.imageView setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:0]]];
            }
            else
            {
                [self.imageView setImageWithURL:[NSURL URLWithString:_newsElementDetail.imageUrl]];
            }
            
            
        }
        else
        {
            self.imageView.image = [UIImage imageNamed:@"glnews.png"];
        }
    
    
   
    
    NSLog(@"%@",_newsElementDetail.imageUrl);
}




@end

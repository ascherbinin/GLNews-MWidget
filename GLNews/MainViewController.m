//
//  MainViewController.m
//  GLNews
//
//  Created by Admin on 06.05.15.
//  Copyright (c) 2015 GoodLine. All rights reserved.
//

#import "MainViewController.h"

#import "MainTableCell.h"
#import "LoadCell.h"
#import "TFHpple.h"
#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "RDHelper.h"


NSString *const kNewsElement = @"kNewsElement";

@implementation MainViewController


@synthesize sampleTableView;




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableCell" bundle:nil]forCellReuseIdentifier:@"NewsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LoadCell" bundle:nil]forCellReuseIdentifier:@"LoadCell"];
    
    
    self.navigationItem.title = @"Новости"; //Изменение заголовка в navigation bar.
    _pageNumber =1;//Переменная для подсчета текущей страницы.

    [self loadNews:_pageNumber]; // Загрузка новостей на текущей странице.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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


//Метод для построничной загрузки новостей с live.goodline.info
-(void)loadNews:(int) pageNumber
{
    int index = 1;
        // Получение ссылки на текущую страницу live.goodline.info
        NSURL *newsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://live.goodline.info/guest/page%d",pageNumber]];
        
        //Массив элементов в теге article на странице live.goodline.info
        NSArray *newsNodes = [RDHelper requestData:newsUrl xPathQueryStr:@"//article"];
    
        if ([newsNodes count] == 0)
            NSLog(@"Нету node");
        else
        {
            NSLog(@"Найдено %lu корневых элементов", (unsigned long)[newsNodes count]);
            
            //Добавлением в основной массив _objects, полученных из запроса элементов с помощью хелпера RDHelper.
            for (NSMutableArray *arr in [RDHelper parsArray:newsNodes])
            {
                [_objects addObject:arr];
                [self saveNewsElement:(NewsElement*)arr andIndex:index++];
            }
            
        
            
        }
   

            [self.tableView reloadData]; // Перезагрузка данных в таблице после получения все новостей на странице.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
}

- (void)saveNewsElement:(NewsElement*)newsElement andIndex:(int)index {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:newsElement] forKey:[NSString stringWithFormat:@"%@%@",kNewsElement,@(index).stringValue]];
    [defaults synchronize];
}

//Метод для загрузки последней новости при переходе из виджета

-(void) loadLastNewsForWidget
{
    //Создание контроллера для отображения полного текста последней новости
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    if(!_objects.count>0) //Проверка наличия загруженных новостей
    {
        [self loadNews:_pageNumber];
    }
    else
    {
        
        NSLog(@"Ничего не загрузилось в loadLastNewsForWidget");

    }
    
    NewsElement *news = [_objects objectAtIndex:0];
    [detailViewController setDetails:news];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - Работа с data source таблицы
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
       return 1;
}



//Метод для установки высоты ячейки
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
}

//Метод для установки количества ячеек в таблице в зависимости от количества элементов в массиве _objects
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       return [_objects count];
}



//Инициализация каждой ячейки в таблице
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MainTableCell* cell;
  
    if (indexPath.row == [_objects count]-1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LoadCell" forIndexPath:indexPath];
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:100];
        [activityIndicator startAnimating];
    }
    else
    {
        
    
    
   cell = (MainTableCell*)[tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];

    
    
    NewsElement *news = [_objects objectAtIndex:indexPath.row];
    NSArray* images = [news imagesFromContent:news.imageUrl];
    NSString *imageStringURL = [images objectAtIndex:0];
    NSURL* imageURL = [NSURL URLWithString: imageStringURL];
    if(imageURL != nil)
    {
    [cell.imageNews setImageWithURL: imageURL];
    }
    else
    {
        cell.imageNews.image = [UIImage imageNamed:@"glnews.png"]; //Подгрузка картинки заглушки, если нет картинки у новости.
    }
    cell.titleNews.text = news.titleText;
    cell.descriptionNews.text = news.descriptionText;
    cell.dateNews.text = news.dateNewsText;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
    NSLog(@"%ld", (long)indexPath.row);
    }
    return cell;
}

#pragma mark - Работа с делегатом таблицы

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Создание контроллера для отображения полного текста новости
    _detailViewController = nil;
    _detailViewController = [[DetailViewController alloc] init];
    
    if(indexPath)
    {
        //Получение одной новости из массива в зависимости от выбранной ячейки
        NewsElement *news = [_objects objectAtIndex:indexPath.row];
        //Передача данных новости в контроллер.
        [_detailViewController setDetails:news];
    }
   
    [self.navigationController pushViewController:_detailViewController animated:YES];
    
}

//Функция которая при прокрутке до каждого 9 элемента подгружает следующую страницу live.goodline.info
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section]; //Общее количество ячеек в главной таблице.
   
    if(indexPath.row == totalRow -1)
    {
              NSLog(@"Page Number - %d",(int)_pageNumber+1);
            _pageNumber += 1;
        [self loadNews:_pageNumber];
        
        
        
    }
}


@end

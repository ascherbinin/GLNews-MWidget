//
//  MainViewController.m
//  GLNews
//
//  Created by Admin on 06.05.15.
//  Copyright (c) 2015 GoodLine. All rights reserved.
//

#import "MainViewController.h"
#import "NewsElement.h"
#import "MainTableCell.h"
#import "TFHpple.h"
#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "RDHelper.h"


@implementation MainViewController


@synthesize sampleTableView;
@synthesize pageNumber;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"Новости"; //Изменение заголовка в navigation bar.
    pageNumber =1;//Переменная для подсчета текущей страницы.

    [self loadNews]; // Загрузка новостей на текущей странице.
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
-(void)loadNews
{
        // Получение ссылки на текущую страницу live.goodline.info
        NSURL *newsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://live.goodline.info/guest/page%d",pageNumber]];
        
        //Массив элементов в теге article на странице live.goodline.info
        NSArray *newsNodes = [RDHelper requestData:newsUrl xPathQueryStr:@"//article"];
    
        if ([newsNodes count] == 0)
            NSLog(@"Нету node");
        else
        {
            NSLog(@"Найдено %lu корневых элементов", (unsigned long)[newsNodes count]);
            
            for (NSMutableArray *arr in [RDHelper parsArray:newsNodes]) {
                //Добавлением в основной массив _objects, полученных из запроса элементов с помощью хелпера RDHelper.
                [_objects addObject:arr];
            }
            
        
            
        }
   
            [self.tableView reloadData]; // Перезагрузка данных в таблице после получения все новостей на странице.
    
}

//Метод для загрузки последней новости при переходе из виджета

-(void) loadLastNewsForWidget
{
    //Создание контроллера для отображения полного текста последней новости
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    if(!_objects.count>0) //Проверка наличия загруженных новостей
    {
        [self loadNews];
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
    
  
    static NSString *CellIdentifier = @"NewsCell";
    MainTableCell *cell = (MainTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
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
    
    return cell;
}

#pragma mark - Работа с делегатом таблицы

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    
    //Создание контроллера для отображения полного текста новости
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    if(indexPath)
    {
        //Получение одной новости из массива в зависимости от выбранной ячейки
        NewsElement *news = [_objects objectAtIndex:indexPath.row];
        //Передача данных новости в контроллер.
        [detailViewController setDetails:news];
    }
   
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

//Функция которая при прокрутке до каждого 7 элемента подгружает следующую страницу live.goodline.info
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section]; //Общее количество ячеек в главной таблице.
   
    if(indexPath.row == totalRow -3)
    {
              NSLog(@"Page Number - %d",(int)pageNumber+1);
            pageNumber += 1;
            [self loadNews];
        
        
        
    }
}


@end

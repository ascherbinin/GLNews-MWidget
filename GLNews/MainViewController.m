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

@interface MainViewController ()
{
   
}
@end

@implementation MainViewController


@synthesize sampleTableView;
@synthesize pageNumber;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"Новости";
    pageNumber =1;

    [self loadNews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)loadNews
{
    
    NSURL *newsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://live.goodline.info/guest/page%d",pageNumber]];
   
  
    NSArray *newsNodes = [RDHelper requestData:newsUrl xPathQueryStr:@"//article"];
    
    
    //[newsParser searchWithXPathQuery:newsXpathQueryString];
    
    
    
    if ([newsNodes count] == 0)
        NSLog(@"Нету node");
    else
    {
        NSLog(@"Найдено %lu корневых элементов", (unsigned long)[newsNodes count]);
   
        
        
        //NSMutableArray *newNews = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (TFHppleElement *element in newsNodes){
            
            
            
            
            NewsElement *ne = [[NewsElement alloc]init];
            
            
            
            TFHppleElement *subelement = [element firstChildWithClassName:@"wraps out-topic"];
            TFHppleElement *descriptionElement = [subelement firstChildWithClassName:@"topic-content text"];
            TFHppleElement *titleElement =[subelement firstChildWithClassName:@"topic-header"] ;
            TFHppleElement *imageElement = [element firstChildWithClassName:@"preview"];
            
          //  (NSLog(@"Description element - %@",[[titleElement firstChildWithTagName:@"time"]content])) ;
          
            ne.titleText =[[[titleElement firstChildWithClassName:@"topic-title word-wrap"] content]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            ne.descriptionText =[[descriptionElement content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *dateString = [[[titleElement firstChildWithTagName:@"time"]content]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSScanner *scanner = [[NSScanner alloc] initWithString:dateString];
            [scanner scanUpToString:@"," intoString:nil];
            ne.dateNewsText = [dateString substringWithRange:NSMakeRange(0, scanner.scanLocation)];
            
            TFHppleElement *imageNode = [[imageElement firstChildWithTagName:@"a"] firstChildWithTagName:@"img"];
           
            ne.imageUrl = [imageNode objectForKey:@"src"];
            
           
            
            NSString *urlString = [[[titleElement firstChildWithTagName:@"h2"]firstChildWithTagName:@"a"] objectForKey:@"href"];
            ne.articleUrl =[NSURL URLWithString:urlString];
            
            
            [_objects addObject:ne];
    }
    
        
        
        
    [self.tableView reloadData];
    
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    // Usually the number of items in your array (the one that holds your list)
    return [_objects count];
}


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
        cell.imageNews.image = [UIImage imageNamed:@"glnews.png"];
    }
    cell.titleNews.text = news.titleText;
    cell.descriptionNews.text = news.descriptionText;
    cell.dateNews.text = news.dateNewsText;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
    NSLog(@"%ld", (long)indexPath.row);
   
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    // If you want to push another view upon tapping one of the cells on your table.
    
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    if(indexPath)
    {
        NewsElement *news = [_objects objectAtIndex:indexPath.row];
        [detailViewController setDetails:news];
    }
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // issue when dragin to the VERY last cell
    
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
    if(indexPath.row == totalRow -3)
    {
              NSLog([NSString stringWithFormat:@"Page Number - %d",pageNumber+1]);
            pageNumber += 1;
            [self loadNews];
        
        
        
    }
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

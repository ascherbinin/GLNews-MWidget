//
//  ImageCollectionViewController.m
//  GLNews
//
//  Created by Андрей Щербинин on 02.06.15.
//  Copyright (c) 2015 GoodLine. All rights reserved.
//

#import "ImageCollectionViewController.h"
#import "ImageCollectionCell.h"
#import "UIImageView+AFNetworking.h"

@interface ImageCollectionViewController ()
@property NSArray* photoArray;
@end

@implementation ImageCollectionViewController

@synthesize collectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCell"]; //регистрация nib файла для кастомной ячейки галереи.
    
}

-(id)initWithArray:(NSArray*)photoArray
{
    self = [super init];
    
    if (self) {
        _photoArray = [[NSArray alloc]initWithArray:photoArray];
    }
    
    return  self;
    
}

//Инициализация контроллера с входящим массивом
-(id)initWithArray:(NSArray *)photoArray andIndexPath:(NSIndexPath *)imageIndexPath
{
    self = [super init];
    
    if (self) {
        _photoArray = [[NSArray alloc]initWithArray:photoArray];
       
    }
    
    return  self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

//Метод который устанавливает количество элементов в коллекции из количества элементов массива
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  [_photoArray count];
}

//Ининциализация ячеек коллекции из полученного массива.
-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    NSString *imageStringURL = [_photoArray objectAtIndex:indexPath.row];
    NSURL* imageURL = [NSURL URLWithString: imageStringURL];
    
    [cell.imageView setImageWithURL:imageURL];
       return cell;
}

//Метод который задает размеры ячейки в коллекции.
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-240); //Размер по ширине на весь экран по высоте экран-240 пунктов.
}




@end

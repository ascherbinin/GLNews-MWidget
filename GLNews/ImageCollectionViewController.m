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
    
    
    [collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCell"];
    
}

-(id)initWithArray:(NSArray*)photoArray
{
    self = [super init];
    
    if (self) {
        _photoArray = [[NSArray alloc]initWithArray:photoArray];
    }
    
    return  self;
    
}

-(id)initWithArray:(NSArray *)photoArray andIndexPath:(NSIndexPath *)imageIndexPath
{
    self = [super init];
    
    if (self) {
        _photoArray = [[NSArray alloc]initWithArray:photoArray];
       
    }
    
    return  self;
}

-(void)viewWillAppear:(BOOL)animated
{
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  [_photoArray count];
}


-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    NSString *imageStringURL = [_photoArray objectAtIndex:indexPath.row];
    NSURL* imageURL = [NSURL URLWithString: imageStringURL];
    [cell.imageView setImageWithURL:imageURL];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-240);
}



@end

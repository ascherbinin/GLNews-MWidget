//
//  ImageCollectionViewController.h
//  GLNews
//
//  Created by Андрей Щербинин on 02.06.15.
//  Copyright (c) 2015 GoodLine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
-(id)initWithArray:(NSArray*)photoArray;
@end

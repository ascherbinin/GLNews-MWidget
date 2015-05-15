//
//  NewsElement.h
//  GLNews
//
//  Created by Admin on 06.05.15.
//  Copyright (c) 2015 GoodLine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsElement : NSObject

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *descriptionText;
@property (nonatomic, copy) NSString *dateNewsText;
@property (nonatomic, copy) NSURL *articleUrl;

-(NSArray *)imagesFromContent:(NSString*)contentStr;
-(NSArray *)imagesFromHTMLString:(NSString *)htmlstr;
@end

//
//  NewsElement.m
//  GLNews
//
//  Created by Admin on 06.05.15.
//  Copyright (c) 2015 GoodLine. All rights reserved.
//

#import "NewsElement.h"



@implementation NewsElement

@synthesize imageName = image;
@synthesize titleText = title;
@synthesize descriptionText = description;
@synthesize dateNewsText = date;
@synthesize imageUrl = imageUrl;
@synthesize articleUrl = url;


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        image = [aDecoder decodeObjectForKey:@"imageName"];
        title = [aDecoder decodeObjectForKey:@"titleText"];
        description = [aDecoder decodeObjectForKey:@"descriptionText"];
        date = [aDecoder decodeObjectForKey:@"dateNews"];
        imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
        url = [aDecoder decodeObjectForKey:@"articleURL"];
       }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:image forKey:@"imageName"];
    [aCoder encodeObject:title forKey:@"titleText"];
    [aCoder encodeObject:description forKey:@"descriptionText"];
    [aCoder encodeObject:date forKey:@"dateNews"];
    [aCoder encodeObject:imageUrl forKey:@"imageUrl"];
    [aCoder encodeObject:url forKey:@"articleURL"];
}

//Метод получения массива ссылок на изображения из html кода.
-(NSArray *)imagesFromContent:(NSString*)contentStr
{
    if (contentStr) {
        return [self imagesFromHTMLString:contentStr];
    }
    
    return nil;
}



-(NSArray *)imagesFromHTMLString:(NSString *)htmlstr
{
    NSMutableArray *imagesURLStringArray = [[NSMutableArray alloc] init];
    
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"(https?)\\S*(png|jpg|jpeg|gif)"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    
    [regex enumerateMatchesInString:htmlstr
                            options:0
                              range:NSMakeRange(0, htmlstr.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             [imagesURLStringArray addObject:[htmlstr substringWithRange:result.range]];
                         }];
    
    return [NSArray arrayWithArray:imagesURLStringArray];
}

@end



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



-(NSArray *)imagesFromContent:(NSString*)contentStr
{
    if (contentStr) {
        return [self imagesFromHTMLString:contentStr];
    }
    
    return nil;
}
#pragma mark - retrieve images from html string using regexp (private methode)

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



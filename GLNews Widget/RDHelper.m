//
//  RDHelper.m
//  GLNews
//
//  Created by Admin on 08.05.15.
//  Copyright (c) 2015 GoodLine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"


@interface RDHelper : NSObject



@end


@implementation RDHelper

+(NSArray*)requestData:(NSURL*)urlString xPathQueryStr:(NSString*)xpathQueryString
{
    
    NSData *newHtmlData = [NSData dataWithContentsOfURL:urlString];
    
    TFHpple *newParser = [TFHpple hppleWithHTMLData:newHtmlData];
    
    NSString *newXpathQueryString = xpathQueryString;
    
    NSArray *newNodes = [newParser searchWithXPathQuery:newXpathQueryString];
    
    return newNodes;
}


@end
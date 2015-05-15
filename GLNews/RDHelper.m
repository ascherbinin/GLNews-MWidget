//
//  RDHelper.m
//  GLNews
//
//  Created by Admin on 08.05.15.
//  Copyright (c) 2015 GoodLine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"
#import "NewsElement.h"

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

+(NSMutableArray*)parsArray:(NSArray*)arrayToPars
{
    NSMutableArray *tempMArray = [[NSMutableArray alloc]init];
    
    for (TFHppleElement *element in arrayToPars){
        
        
        
        
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
        
        
        [tempMArray addObject:ne];
    }
    
    return tempMArray;
}


@end
//
//  WTOfficialMSGXMLDelegate.m
//  omim
//
//  Created by coca on 14-3-31.
//  Copyright (c) 2014年 OneMeter Inc. All rights reserved.
//

#import "WTOfficialMSGXMLDelegate.h"
//#import "WTUserDefaults.h"

@interface WTOfficialMSGXMLDelegate ()

@property (nonatomic, retain) NSMutableDictionary *xmlDataDictionary;
@property (nonatomic, retain) NSMutableArray *stackArray;

@end

@implementation WTOfficialMSGXMLDelegate

@synthesize delegate;
@synthesize msg;
@synthesize xmlDataDictionary = _xmlDataDictionary;
@synthesize stackArray = _stackArray;

- (id)init
{
    self = [super init];
    if (self)
    {
        wxhValue = WXH_BAD;
        wxcValue = WXC_NOTSET;
        isInsideElement = NO;
        curNodeName = nil;
        self.xmlDataDictionary = [[[NSMutableDictionary alloc] init] autorelease];
        self.stackArray = [[[NSMutableArray alloc] init] autorelease];
        [self.stackArray addObject:self.xmlDataDictionary];
    }
    
    return self;
}

- (void)dealloc
{
    self.stackArray = nil;
    self.xmlDataDictionary = nil;
    
    [super dealloc];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    isInsideElement = YES;
    curNodeName = [NSString stringWithString:elementName];
    
    if ([elementName isEqualToString:@"xml"]){
            wxhValue = WXH_BODY;
            wxcValue = WXC_BODY;
    }
   
    
    
    if (wxhValue == WXH_BODY)
    {
        curValue = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (curValue)
        [curValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    isInsideElement = NO;

       
    if ([elementName isEqualToString:@"xml"])
    {
        if ([delegate respondsToSelector:@selector(officialMSGXMLParseFinished: forMsg:)])
            [delegate officialMSGXMLParseFinished:self.xmlDataDictionary forMsg:msg];
    }
    else{
        if (wxhValue == WXH_BODY){
            [self.xmlDataDictionary setObject:curValue forKey:elementName];
        }
        
        [curValue release];
        curValue = nil;

    }
}

@end

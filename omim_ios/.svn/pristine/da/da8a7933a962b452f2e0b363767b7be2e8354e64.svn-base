//
//  omimXMLParser.m
//  omim
//
//  Created by Harry on 12-12-11.
//  Copyright (c) 2012年 WowTech Inc. All rights reserved.
//

#import "WowtalkXMLParser.h"
#import "WTUserDefaults.h"

@interface WowtalkXMLParser ()

@property (nonatomic, retain) NSMutableDictionary *xmlDataDictionary;
@property (nonatomic, retain) NSMutableArray *stackArray;
@property (nonatomic,retain) NSMutableString* curValue;

@end

@implementation WowtalkXMLParser

@synthesize delegate;

@synthesize xmlDataDictionary = _xmlDataDictionary;
@synthesize stackArray = _stackArray;
@synthesize curValue = _curValue;
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
        [self.stackArray addObject:self.xmlDataDictionary];  // nest the 
    }
    
    return self;
}

- (void)dealloc
{
    self.stackArray = nil;
    self.xmlDataDictionary = nil;
    self.curValue = nil;
    
    [super dealloc];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    isInsideElement = YES;
    curNodeName = [NSString stringWithString:elementName];
    
    if ([elementName isEqualToString:XML_ROOT_NAME])
        wxhValue = WXH_GOOD;
    else if ([elementName isEqualToString:XML_HEADER_NAME] && wxhValue == WXH_GOOD)
        wxhValue = WXH_HEADER;
    else if ([elementName isEqualToString:XML_BODY_NAME])
    {
        if (wxhValue == WXH_HEADER)
            wxhValue = WXH_BODY;
        
        if (wxhValue == WXH_BODY)
            wxcValue = WXC_BODY;
    }
    else if ([elementName isEqualToString:XML_BUDDY])
        if (wxhValue == WXH_HEADER)
            wxcValue = WXC_BUDDY;
    
    self.curValue = [[[NSMutableString alloc] init] autorelease];
    
    if (wxhValue == WXH_BODY)  // we create a new dic when we meet a open tag.
    {
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
        [self.stackArray addObject:tempDict];
        [tempDict release];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.curValue)
        [self.curValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
  //  NSString* tempstr = [[(NSString*)curValue stringByTrimmingCharactersInSet:[NSCharacterSet nonBaseCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   // [curValue setString:tempstr];
  
    isInsideElement = NO;
    
    if (wxhValue == WXH_BODY && wxcValue == WXC_BODY)
    {
        if ([elementName isEqualToString:XML_PASSWORD_KEY])
        {
            if (self.curValue != nil && ![self.curValue isEqual:@""]) {
                [WTUserDefaults setHashedPassword:self.curValue]; 
            }
        }
    }
    
    // anaylze header
    if (wxhValue == WXH_HEADER)
    {
        if ([elementName isEqualToString:ERR_NODE_NAME])
            [self.xmlDataDictionary setObject:self.curValue forKey:ERR_NODE_NAME];
        else if ([elementName isEqualToString:SERVER_VERSION_NAME])
        {
            [WTUserDefaults setServerVersion:self.curValue];
        }
        else if ([elementName isEqualToString:CLIENT_VERSION_NAME])
        {
            [WTUserDefaults setClientVersion:self.curValue];
        }
    }
    else if (self.stackArray.count >= 2)
    {
        if (self.curValue != nil && [self.curValue stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n\t\a"]].length > 0 && self.curValue.length > 0)
        {
            // have to store this element into the last dictionary
            [self.stackArray removeLastObject];
            
            NSMutableDictionary *dict = [self.stackArray lastObject];
            //check whether we have same element.
            if ([dict objectForKey:elementName] != nil)
            {
                if ([[dict objectForKey:elementName] isKindOfClass:[NSMutableArray class]])
                {
                    NSMutableArray *arr = [dict objectForKey:elementName];
                    [arr addObject:self.curValue];
                }
                else
                {   //otherwise we create a array and replace it
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    [arr addObject:[dict objectForKey:elementName]];
                    [arr addObject:self.curValue];
                    [dict removeObjectForKey:elementName];
                    [dict setObject:arr forKey:elementName];
                    [arr release];
                }
            }
            else
                [dict setObject:self.curValue forKey:elementName];  // problem occurs here. we have to judge whether the element is single or not outside.
        }
        else
        {
            NSMutableDictionary *lastdict = [[self.stackArray lastObject] retain];
            [self.stackArray removeLastObject];
            
            if (lastdict.allKeys.count == 0){
                [lastdict release];
                return;
            }
            
            NSMutableDictionary *dict = [self.stackArray lastObject];
            if ([dict objectForKey:elementName] != nil)
            {
                if ([[dict objectForKey:elementName] isKindOfClass:[NSMutableArray class]])
                {
                    NSMutableArray *arr = [dict objectForKey:elementName];
                    [arr addObject:lastdict];
                }
                else
                {
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    [arr addObject:[dict objectForKey:elementName]];
                    [arr addObject:lastdict];
                    [dict removeObjectForKey:elementName];
                    [dict setObject:arr forKey:elementName];
                    [arr release];
                }
            }
            else
                [dict setObject:lastdict forKey:elementName];  // problem occurs here. we have to judge whether the element is single or not outside.
            
            [lastdict release];
        }
    }
    
    self.curValue = nil;
    
    
    // take care the final element
    if ([elementName isEqualToString:XML_ROOT_NAME])
    {
        @try {
            if ([delegate respondsToSelector:@selector(wowtalkXMLParseFinished:)])
                [delegate wowtalkXMLParseFinished:self.xmlDataDictionary];
        } @catch (NSException *exception) {
            NSLog(@"Caught Exception when xml parse finished:%@-%@", [exception name], [exception reason]);
        } @finally {
            //none finally handle
        }
    }
}

@end

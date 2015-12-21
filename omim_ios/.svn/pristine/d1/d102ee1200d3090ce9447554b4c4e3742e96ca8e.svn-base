
//The MIT License (MIT)
//
//Copyright (c) 2013 Rafał Augustyniak
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "RADataObject.h"

@implementation RADataObject

-(void)dealloc{
    [_objectID release];
    [_name release];
    [_children release];
    [_upload_photo_timestamp release];
    [_person release];
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        _children = [[NSMutableArray alloc]init];
    }
    return self;
}

- (id)initWithName:(NSString *)name children:(NSMutableArray *)children
{
  self = [super init];
  if (self) {
    self.children = [children retain];
    self.name = [name copy];
  }
  return self;
}

+ (id)dataObjectWithName:(NSString *)name children:(NSMutableArray *)children
{
  return [[self alloc] initWithName:name children:children];
}

@end

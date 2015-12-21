

#import <Foundation/Foundation.h>
#import "ChatMessage.h"

@protocol WTOfficialMSGXMLDelegate <NSObject>

@optional
- (void)officialMSGXMLParseFinished:(NSMutableDictionary *)result forMsg:(ChatMessage*)msg;

@end

typedef enum
{
    WXH_BAD = -1,
    WXH_GOOD,
    WXH_HEADER,
    WXH_BODY
}OFFICIALMSG_XML_HEADER_POSITION;

typedef enum
{
    WXC_NOTSET = -1,
    WXC_GOOD,
    WXC_BODY,
    WXC_BUDDY
}OFFICIALMSG_XML_CONTENT_POSITION;


@interface WTOfficialMSGXMLDelegate : NSObject<NSXMLParserDelegate>
{
    BOOL isInsideElement;
    NSString *curNodeName;
    NSMutableString *curValue;
    OFFICIALMSG_XML_HEADER_POSITION wxhValue;
    OFFICIALMSG_XML_CONTENT_POSITION wxcValue;
    
    id<WTOfficialMSGXMLDelegate> delegate;

}

@property (nonatomic, assign) id<WTOfficialMSGXMLDelegate> delegate;
@property (nonatomic,assign) ChatMessage* msg;



@end


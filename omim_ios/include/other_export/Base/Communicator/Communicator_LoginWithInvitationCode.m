#import "Communicator_LoginWithInvitationCode.h"

@implementation Communicator_LoginWithInvitationCode
- (void)wowtalkXMLParseFinished:(NSMutableDictionary *)result
{
    int errNo;
    if ([result objectForKey:ERR_NODE_NAME] == nil)
        errNo = ERROR_CODE_NOT_RETURNED;
    else
        errNo = [[result objectForKey:ERR_NODE_NAME] intValue];
    
    if (errNo == NO_ERROR)
    {
        
        NSMutableDictionary *dict = [result objectForKey:XML_BODY_NAME];
        if (dict == nil || ![dict objectForKey:WT_LOGIN_WITH_INVITATION_CODE]) {
            errNo = NECCESSARY_DATA_NOT_RETURNED;
        } else {
            NSMutableDictionary *infoDict = [dict objectForKey:WT_LOGIN_WITH_INVITATION_CODE];
            
            if (![[WTUserDefaults getUid] isEqualToString:[infoDict objectForKey:UUID]]) {
                [Database dropAllTables:NO];
                [Database teardown];
                [Database initializeDatabase];
                
            }
            
            if([infoDict objectForKey:UUID] && ![[infoDict objectForKey:UUID] isEqual:@""] )[WTUserDefaults setUid:[infoDict objectForKey:UUID]];
            if([infoDict objectForKey:HASHED_PASSWORD]  && ![[infoDict objectForKey:HASHED_PASSWORD] isEqual:@""] )[WTUserDefaults setHashedPassword:[infoDict objectForKey:HASHED_PASSWORD]];
            
            if([infoDict objectForKey:XML_DOMAIN])[WTUserDefaults setDomain:[infoDict objectForKey:XML_DOMAIN]];
            if([infoDict objectForKey:PASSWORD_CHANGED])[WTUserDefaults setPwdChanged:[infoDict objectForKey:PASSWORD_CHANGED]];
            if([infoDict objectForKey:WOWTALK_ID_CHANGED])[WTUserDefaults setIdChanged:[infoDict objectForKey:WOWTALK_ID_CHANGED]];
            if([infoDict objectForKey:XML_EMAIL_ADDRESS_KEY])[WTUserDefaults setEmail:[infoDict objectForKey:XML_EMAIL_ADDRESS_KEY]];
            if([infoDict objectForKey:XML_PHONE_NUMBER_KEY])[WTUserDefaults setPhoneNumber:[infoDict objectForKey:XML_PHONE_NUMBER_KEY]];
            
            if([infoDict objectForKey:@"wowtalk_id"])[WTUserDefaults setWTID:[infoDict objectForKey:@"wowtalk_id"]];
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if([infoDict objectForKey:UUID])[defaults setObject:[infoDict objectForKey:UUID] forKey:@"uid_preference"];
            if([infoDict objectForKey:SIP_PASSWORD])[defaults setObject:[infoDict objectForKey:SIP_PASSWORD] forKey:@"password_preference"];
            if([infoDict objectForKey:XML_DOMAIN]){[defaults setObject:[infoDict objectForKey:XML_DOMAIN] forKey:@"domain_preference"];}
            else{
                [defaults setObject:DEFAULT_DOMAIN forKey:@"domain_preference"];
            }
            [defaults synchronize];
        }
    }
    
    [self networkTaskDidFinishWithReturningData:nil error:[NSError errorWithDomain:ERROR_DOMAIN code:errNo userInfo:nil]];
}
@end

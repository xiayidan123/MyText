//
//  Utility.h
//  omimLibrary
//
//  Created by coca on 14-2-18.
//
//


typedef enum _WowTalkLoggerSeverity {
    WowTalkLoggerLog = 0,
    WowTalkLoggerDebug,
    WowTalkLoggerWarning,
    WowTalkLoggerError,
    WowTalkLoggerFatal
} WowTalkLoggerSeverity;


@interface WowTalkLogger : NSObject {
    
}
+ (void)log:(WowTalkLoggerSeverity) severity format:(NSString *)format,...;
+ (void)logc:(WowTalkLoggerSeverity) severity format:(const char *)format,...;

@end

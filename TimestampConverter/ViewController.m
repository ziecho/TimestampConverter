//
//  ViewController.m
//  TimestampConverter
//
//  Created by zie on 16/4/28.
//  Copyright © 2016年 ziecho.com All rights reserved.
//

#import "ViewController.h"
@interface ViewController()
@property (weak) IBOutlet NSTextField *outputLabel;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, copy) NSString *lastPasteboardString;
@end
@implementation ViewController

- (NSString *)stringFromTimestamp:(double)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy M/d HH:mm:ss"];
    NSString *nowtimeStr = [formatter stringFromDate:date];
    
    return nowtimeStr;
}


- (void)startPolling {
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    uint64_t interval = (uint64_t)((int64_t)(0.1 * NSEC_PER_SEC));
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), interval, 0);
    
    dispatch_source_set_event_handler(self.timer, ^{
        [self polling];
    });
    
    dispatch_resume(self.timer);
}

- (BOOL)isTimestampString:(NSString *)string {
    if (string.length > 14) return NO;
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
}


- (void)polling {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *types = [pasteboard types];
    
    if ([types containsObject:NSStringPboardType]) {
        NSString *pasteboardString = [pasteboard stringForType:NSStringPboardType];
        if ([pasteboardString isEqualToString:self.lastPasteboardString]) return;
        self.lastPasteboardString = pasteboardString;
        if (![self isTimestampString:pasteboardString]) return;
        NSUInteger lengthDiff = (pasteboardString.length > 10) ? pasteboardString.length - 10 : 0;
        double timestamp = lengthDiff ? [pasteboardString integerValue] / pow(10, lengthDiff) : [pasteboardString integerValue];
        NSString  *timeString = [self stringFromTimestamp:timestamp];
        NSString *output = [NSString stringWithFormat:@"%@ -> %@",pasteboardString,timeString];
        [self.outputLabel setStringValue:output];
    }
}
- (void)viewDidLoad {
    [self startPolling];
    
    [super viewDidLoad];
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

@end

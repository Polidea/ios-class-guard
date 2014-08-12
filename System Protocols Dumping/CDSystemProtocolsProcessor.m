#import "CDSystemProtocolsProcessor.h"


@implementation CDSystemProtocolsProcessor {
    NSString *_sdkPath;
}

- (id)initWithSdkPath:(NSString *)sdkPath {
    self = [super init];
    if (self) {
        _sdkPath = sdkPath;
    }

    return self;
}

- (NSArray *)systemProtocolsSymbolsToExclude {
    NSString *argument = [NSString stringWithFormat:@"find %@/System/Library/Frameworks  -name \"*.h\" -exec sed -n -e 's/.*@protocol[ \\t]*\\([a-zA-Z_][a-zA-Z0-9_]*\\).*/\\1/p' \"{}\" \\+", _sdkPath];
    NSArray *arguments = @[@"-c", argument];

    NSTask *task = [[NSTask alloc] init];
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = pipe.fileHandleForReading;
    [task setLaunchPath: @"/bin/bash"];
    task.arguments = arguments;
    task.standardOutput = pipe;
    [task launch];
    [task waitUntilExit];

    NSData *data = [file readDataToEndOfFile];
    [file closeFile];

    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return [output componentsSeparatedByString:@"\n"];
}

@end

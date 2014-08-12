#import <Kiwi/Kiwi.h>
#import "CDSystemProtocolsProcessor.h"


SPEC_BEGIN(CDSystemProtocolsProcessorSpec)
    describe(@"CDSystemProtocolsProcessor", ^{
        __block CDSystemProtocolsProcessor *parser;
        __block NSString *sdkPath;

        beforeEach(^{
            NSString *root = @"7.1";
            if ([[NSFileManager defaultManager] fileExistsAtPath: @"/Applications/Xcode.app"]) {
                sdkPath = [NSString stringWithFormat:@"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS%@.sdk", root];
            } else if ([[NSFileManager defaultManager] fileExistsAtPath: @"/Developer"]) {
                sdkPath = [NSString stringWithFormat:@"/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS%@.sdk", root];
            }

            parser = [[CDSystemProtocolsProcessor alloc] initWithSdkPath:sdkPath];
        });

        describe(@"retrieving protocol symbols to exclude", ^{
            __block NSArray *symbols;
            beforeAll(^{
                symbols = [parser systemProtocolsSymbolsToExclude];
            });

            it(@"should retrieve 302 strings", ^{
                [[@(symbols.count) should] equal:(theValue(302))];
            });

            it(@"should contain UIWebViewDelegate, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate", ^{
                [[symbols should] contain:@"UIWebViewDelegate"];
                [[symbols should] contain:@"UIPickerViewDelegate"];
                [[symbols should] contain:@"UITableViewDelegate"];
                [[symbols should] contain:@"UITableViewDataSource"];
                [[symbols should] contain:@"UINavigationControllerDelegate"];
            });
        });
    });
SPEC_END

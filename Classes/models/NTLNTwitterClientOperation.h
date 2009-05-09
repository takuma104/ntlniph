#import <Foundation/Foundation.h>
#import "NTLNTwitterClient.h"

@interface NTLNTwitterClientOperation : NSOperation {
	NTLNTwitterClient* client;
}

- (id)initWithClient:(NTLNTwitterClient*)client;

@end

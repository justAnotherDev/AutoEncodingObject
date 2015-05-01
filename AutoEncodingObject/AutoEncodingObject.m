//
//  AutoEncodingObject.m
//
//  Created by Casey E on 4/30/15.
//

#import "AutoEncodingObject.h"
#import <objc/runtime.h>

@implementation AutoEncodingObject

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	void (^decodeBlock)(Ivar, NSString*) = ^(Ivar ivar, NSString *name) {
		// decode the object
		id decodedObject = [aDecoder decodeObjectForKey:name];
		
		// set ivar to be the decoded object
		if (decodedObject) {
			object_setIvar(self, ivar, decodedObject);
		}
	};
	
	// decode all NSCoding compliant properties
	[self _performBlockOnCompliantProperties:decodeBlock];
	
	return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
	
	void (^encodeBlock)(Ivar, NSString*) = ^(Ivar ivar, NSString *name) {
		// get the ivar's current value
		id object = object_getIvar(self, ivar);
		
		// encode the object or log error if not compliant
		if ([object conformsToProtocol:@protocol(NSCoding)]) {
			[encoder encodeObject:object forKey:name];
		} else {
			NSLog(@"Error: %@'s property %@ will not be saved since it is not NSCoding compliant. If this is intended then add the property to propertiesToIgnore to silence this message.", NSStringFromClass([self class]), name);
		}
	};
	
	// encode all NSCoding compliant properties
	[self _performBlockOnCompliantProperties:encodeBlock];
}

- (void)_performBlockOnCompliantProperties:(void (^)(Ivar, NSString*))block {
	// retrieve any properties that shouldn't be handled by AutoEncodingObject
	NSArray *ignoreUs = [self propertiesToIgnore];
	
	// iterate through all of the instance variables for this class
	unsigned int count;
	Ivar* ivars=class_copyIvarList([self class], &count);
	for(int i=0; i < count; i++) {
		Ivar ivar= ivars[i];
		
		// see if this ivar should be ignored
		NSString *key = [NSString stringWithFormat:@"%s", ivar_getName(ivar)];
		if ([ignoreUs containsObject:[key substringFromIndex:1]]) {
			continue;
		}
		
		// allow the block to encode or decode the object
		block(ivar, key);
	}
	free(ivars);
}

@end

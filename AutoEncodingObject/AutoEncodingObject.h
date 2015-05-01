//
//  AutoEncodingObject.h
//
//  Created by Casey E on 4/30/15.
//

#import <Foundation/Foundation.h>

/**
 @brief Helper class for NSCoding compliance. Any subclass of AutoEncodingObject will have all of it's
 properties automatically encoded and decoded.
 */
@interface AutoEncodingObject : NSObject <NSCoding>

/**
 @brief A subclass may set this property if it wishes to custom handle specific instance variables.
 @return An array of instance variable names in NSString format.
 */
@property(nonatomic, strong) NSArray *propertiesToIgnore;

@end

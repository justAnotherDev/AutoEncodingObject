#AutoEncodingObject

## What?

Easy NSCoding compliant objects without all the boilerplate. No more copy paste errors or forgetting to encode/decode properties.

Allows for custom handling of encoding and decoding if advanced logic is necessary.

## Why?

NSKeyedArchiver is [AWESOME](http://nshipster.com/nscoding/ "NSHipster Article on NSCoding/NSKeyedArchiver") and I am using it in most of my projects now. I find it especially useful for sharing custom objects between different targets (Today extension, Watch, iOS apps). 

That being said, the amount of boilerplate code around NSCoding compliance is scary. Also it is really easy to later add a property to the class but then forget to encode/decode it.


<b>AutoEncodingObject</b> solves this problem and makes creating serializable classes a breeze. Other solutions, like [Mantle](https://github.com/github/Mantle "Mantle"), exist to solve this problem, however I find them to be overkill for what I needed.



### Current Way
```objc
@interface SomeObject : NSObject <NSCoding>
@property (nonatomic, strong) NSString *someString;
@property (nonatomic, strong) UIColor *someColor;
@property (nonatomic, strong) NSNumber *someNumber;
@end

@implementation SomeObject
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _someString = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(someString))];
        _someColor = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(someColor))] ;
        _someNumber = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(someNumber))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_someString forKey:NSStringFromSelector(@selector(someString))];
    [encoder encodeObject:_someColor forKey:NSStringFromSelector(@selector(someColor))];
    [encoder encodeObject:_someNumber forKey:NSStringFromSelector(@selector(someNumber))];
}
@end
```

### New Way
```objc
@interface SomeObject : AutoEncodingObject
@property (nonatomic, strong) NSString *someString;
@property (nonatomic, strong) UIColor *someColor;
@property (nonatomic, strong) NSNumber *someNumber;
@end

@implementation SomeObject
@end
```


## Custom Handling

Custom handling of properties has been designed to be as easy as possible.

```objc
@interface SomeObject : AutoEncodingObject
@property (nonatomic, strong) NSString *someString;
@property (nonatomic, strong) UIColor *someColor;
@property (nonatomic, strong) NSNumber *someNumber;
@property (nonatomic, strong) CustomObject *someObject;
@end

@implementation SomeObject
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // perform custom decoding here
        _someObject = [[CustomObject alloc] initWithSavedState];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];

    // perform custom encoding here
    [_someObject saveStateForLater];
}

- (NSArray *)propertiesToIgnore {
    return @[NSStringFromSelector(@selector(someObject))];
}
@end
```

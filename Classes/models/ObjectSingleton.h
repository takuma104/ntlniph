#define OBJECT_SINGLETON_TEMPLATE(_object_name_, _shared_obj_name_) \
static _object_name_ *z##_shared_obj_name_ = nil;  \
+ (_object_name_ *)_shared_obj_name_ {             \
@synchronized(self) {                            \
if (z##_shared_obj_name_ == nil) {             \
z##_shared_obj_name_ = [[self alloc] init];                                               \
}                                              \
}                                                \
return z##_shared_obj_name_;                     \
}                                                  \
+ (id)allocWithZone:(NSZone *)zone {               \
@synchronized(self) {                            \
if (z##_shared_obj_name_ == nil) {             \
z##_shared_obj_name_ = [super allocWithZone:zone]; \
return z##_shared_obj_name_;                 \
}                                              \
}                                                \
return nil;                                      \
}                                                  \
- (id)retain {                                     \
return self;                                     \
}                                                  \
- (NSUInteger)retainCount {                        \
return NSUIntegerMax;                            \
}                                                  \
- (void)release {                                  \
}                                                  \
- (id)autorelease {                                \
return self;                                     \
}                                                  \
- (id)copyWithZone:(NSZone *)zone {                \
return self;                                     \
}


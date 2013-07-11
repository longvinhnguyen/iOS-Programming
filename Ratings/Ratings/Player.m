
#import "Player.h"

@implementation Player

- (id)init
{
    if (self = [super init]) {
        self.playerID = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super init]))
	{
		self.name = [aDecoder decodeObjectForKey:@"Name"];
		self.game = [aDecoder decodeObjectForKey:@"Game"];
		self.rating = [aDecoder decodeIntForKey:@"Rating"];
        self.playerID = [aDecoder decodeObjectForKey:@"ID"];
	}
	return self;
}
 
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.name forKey:@"Name"];
	[aCoder encodeObject:self.game forKey:@"Game"];
	[aCoder encodeInt:self.rating forKey:@"Rating"];
    [aCoder encodeObject:self.playerID forKey:@"ID"];
}

@end

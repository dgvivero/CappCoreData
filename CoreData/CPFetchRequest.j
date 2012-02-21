//
//  CPFetchRequest.j
//
//  Created by Raphael Bartolome on 11.11.09.
//

@import <Foundation/CPObject.j>

//TODO implement
@implementation CPFetchRequest : CPObject
{
 	CPEntityDescription _entity @accessors(property=entity);
	CPInteger _fetchLimit @accessors(property=fetchLimit);
  	CPPredicate _predicate @accessors(property=predicate);
	CPArray _sortDescriptors @accessors(property=sortDescriptors);
}

- (id)initWithEntity:(CPEntityDescription)aEntity 
		   predicate:(CPPredicate)aPredicate 
	 sortDescriptors:(CPArray)sortDescriptors  
		  fetchLimit:(CPInteger) aFetchLimit
{
	if(self = [super init])
	{
		_entity = aEntity;
		_predicate = aPredicate;
		_sortDescriptors = sortDescriptors;
		_fetchLimit = aFetchLimit;
	}
	
	return self;
}

- (id)initWithEntity:(CPEntityDescription)aEntity 
		   predicate:(CPPredicate)aPredicate 
{
	if(self = [super init])
	{
		_entity = aEntity;
		_predicate = aPredicate;
		_sortDescriptors = nil;
		_fetchLimit = 0;
	}
	
	return self;
}

@end

var CPFetchRequestEntityKey   = @"CPFetchRequestEntityKey",
    CPFetchRequestPredicateKey = @"CPFetchRequestPredicateKey",
	CPFetchRequestSortDescriptorsKey  = @"CPFetchRequestSortDescriptorsKey",
	CPFetchRequestFetchLimitKey  = @"CPFetchRequestFetchLimitKey";

@implementation CPFetchRequest (CPCoding)
 
-(id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];

    if (self)
   {
      	_entity = [aCoder decodeObjectForKey:CPFetchRequestEntityKey];
		_predicate = [aCoder decodeObjectForKey:CPFetchRequestPredicateKey];
		_sortDescriptors = [aCoder decodeObjectForKey:CPFetchRequestSortDescriptorsKey];
		_fetchLimit = [aCoder decodeIntForKey:CPFetchRequestEntityKey];
		 
   }

    return self;
}




- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:_entity forKey:CPFetchRequestEntityKey];
    [aCoder encodeObject:_predicate forKey:CPFetchRequestPredicateKey];
    [aCoder encodeObject:_sortDescriptors forKey:CPFetchRequestSortDescriptorsKey];
    [aCoder encodeInt:_fetchLimit forKey:CPFetchRequestFetchLimitKey];
}
@end
//
//  CPManagedObjectID.j
//
//  Created by Raphael Bartolome on 07.10.09.
//

@import <Foundation/Foundation.j>


@implementation CPManagedObjectID : CPObject
{
	CPEntityDescription _entity @accessors(property=entity);
	CPManagedObjectContext _context @accessors(property=context);
	CPPersistantStore _store @accessors(property=store);
	id _globalID @accessors(property=globalID);
	id _localID @accessors(setter=setLocalID:);
	BOOL _isTemporary @accessors(property=isTemporary);
}

+ (id)createLocalID
{
	return [CPString UUID];
}

- (id)initWithEntity:(CPEntityDescription) entity globalID:(id)globalID isTemporary:(BOOL)isTemporary
{
	if(self = [super init])
	{
		_entity = entity;
		if(isTemporary == YES && globalID == nil)
		{
			_isTemporary = isTemporary;
			_globalID = globalID;
			_localID = [CPManagedObjectID createLocalID];
		}
		else
		{
			_globalID = globalID;
			_localID = [CPManagedObjectID createLocalID];
			_isTemporary = isTemporary;
		}
	}
	
	return self;
}

- (CPEntityDescription) entity
{
	return _entity;
}

- (id)localID
{
	if(_localID == nil)
		_localID = [CPManagedObjectID createLocalID];
		
	return _localID;
}

- (BOOL)validatedLocalID
{
	if(_localID != nil && [_localID length] > 0)
		return YES;
		
	return NO;
}

- (BOOL)validatedGlobalID
{
	if(_globalID != nil && [_globalID length] > 0)
		return YES;
		
	return NO;
}

- (BOOL) isEqualToLocalID: (CPManagedObjectID) otherID
{
	if(otherID == nil || [otherID localID] == nil || ![[self localID] isEqual:[otherID localID]])
	{
      return NO;
    }
	
	return YES;
}

- (BOOL) isEqualToGlobalID: (CPManagedObjectID) otherID
{
	if(otherID == nil || [otherID globalID] == nil || ![[self globalID] isEqual:[otherID globalID]])
	{
      return NO;
    }
	
	return YES;
}

//TODO check if this method is necessary
- (BOOL) isEqual: (CPManagedObjectID) otherID
{
	if(![[self globalID] isEqual:[otherID globalID]] &&
		[self isEqualToLocalID: otherID])
	{
      return NO;
    }
	
	return YES;
}

- (void)updateWithObjectID:(CPManagedObjectID)newObjectID
{
	_globalID = [newObjectID globalID];
	_isTemporary = [newObjectID isTemporary];
	
	if([self localID] == nil || [[self localID] length] <= 0)
	{
		[self setLocalID: [self createLocalID]];
	}
}

- (CPString)entityName
{
	return [_entity name];
}


- (CPNumber)_isTemporaryNumber
{
	return [CPNumber numberWithBool:_isTemporary];
}


- (CPString)stringRepresentation
{
	var result = "\n";
	result = result + "\n";
	result = result + "-CPManagedObjectID-";
	result = result + "\n***********";
	result = result + "\n";
	result = result + "localID:" + [self localID] + ";";
	result = result + "\n";
	result = result + "globalID:" + [self globalID] + ";";

	return result;
}

@end

@implementation CPManagedObjectID (CPCoding)
 
- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];

    if (self)
   {
       	 _entity = [aCoder decodeObjectForKey:@"CPManagedObjectObjectIDEntityKey"]
		_globalID = [_globalID decodeObjectForKey:@"CPManagedObjectObjectIDGlobalIDKey"];
		_localID = [aCoder decodeObjectForKey:@"CPManagedObjectIDLocalIDKey"];
		_isTemporary = [aCoder decodeBoolForKey:@"CPManagedObjectIDIsTemporaryKey"];
		 
   }

    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:_entity forKey:@"CPManagedObjectObjectIDEntityKey"];
	[aCoder encodeObject:_globalID forKey:@"CPManagedObjectObjectIDGlobalIDKey"];
	[aCoder encodeObject:_localID forKey:@"CPManagedObjectIDLocalIDKey"];
	[aCoder encodeBool:_isTemporary forKey:@"CPManagedObjectIDIsTemporaryKey"];
	
    
}

@end
//
//  CPPersistentStoreCoordinator.j
//
//  Created by Raphael Bartolome on 25.01.10.
//

@import <Foundation/Foundation.j>

@implementation CPPersistentStoreCoordinator : CPObject
{
	CPManagedObjectModel _model @accessors(property=managedObjectModel);
	CPDictionary _persistentStores @accessors(property=persistentStores);
	CPPersistantStore _persistantStore @accessors(property=persistantStore);
	CPUndoManager _undoManager;
}

- (id) initWithManagedObjectModel: (NSManagedObjectModel *) aModel
{
	if ((self = [super init]))
	{
		_model = model
		_undoManager = [CPUndoManager new];
		_persistentStores = [CPDictionary new];
	}
	
	return self;	
}


- (id) initWithManagedObjectModel:(CPManagedObjectModel)model
				 		storeType:(CPPersistantStoreType) aStoreType
			   storeConfiguration:(id) aConfiguration
{
	if ((self = [super init]))
	{
		_model = model
		_undoManager = [CPUndoManager new];
		[self addPersistentStoreWithType:aStoreType configuration:aConfiguration];		
	}
	
	return self;
}


// Managing the persistent stores.
- (id) addPersistentStoreWithType: (CPPersistantStoreType) aStoreType
                    configuration: (id) aConfiguration
{
	var storeClass = [aStoreType storeClass];
	var store = [[storeClass alloc] init];
	[store setConfiguration: aConfiguration];
	[store setStoreCoordinator:self];
	_persistantStore = store;
}

- (BOOL) removePersistentStore: (id) aPersistentStore
                         error: (NSError **) errorPointer
{
	//Unimplemented
}

- (id) migratePersistentStore: (id) aPersistentStore
                        toURL: (NSURL *) aURL
                      options: (NSDictionary *) options
                     withType: (NSString *) newStoreType
                        error: (NSError **) errorPointer
{
	//Unimplemented
}


- (CPUndoManager) undoManager
{
  return _undoManager;
}

- (void) setUndoManager: (CPUndoManager) aManager
{
	_undoManager = aManager;
}


- (void) undo
{
	[_undoManager undo];
}

- (void) redo
{
	[_undoManager redo];
}

@end

@implementation CPPersistentStoreCoordinator (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
	self = [super init];

	if (self)
	{		
		_model= [aCoder decodeObjectForKey: @"CPPersistentStoreCoordinatorModelKey"];
		_persistentStores = [aCoder decodeObjectForKey: @"CPPersistentStoreCoordinatorPersistantStoresKey"];
		_persistantStore= [aCoder decodeObjectForKey: @"CPPersistentStoreCoordinatorPersistanStoreKey"];
		_undoManager= [aCoder decodeObjectForKey: @"CPPersistentStoreCoordinatorUndoManagerKey"];
		
	}
	return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:_model forKey:@"CPPersistentStoreCoordinatorModelKey"];
    [aCoder encodeObject:_persistentStores forKey:@"CPPersistentStoreCoordinatorPersistantStoresKey"];
	[aCoder encodeObject:_persistantStore forKey:@"CPPersistentStoreCoordinatorPersistanStoreKey"];
    [aCoder encodeObject:_undoManager forKey:@"CPPersistentStoreCoordinatorUndoManagerKey"];
}
@end
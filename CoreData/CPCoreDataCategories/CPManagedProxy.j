@import <Foundation/CPObject.j>
@import <CoreData/CPEntityDescription.j>
@import <CoreData/CPManagedObjectContext.j>
@import <CoreData/CPManagedObject.j>
@import <CoreData/CPFetchRequest.j>



var CPEntityName = "CPEntityName";

@implementation  CPManagedProxy : CPProxy
{
  CPManagedObject _object;
  CPEntityDescription _entity;
  CPString _entityName;
  CPPredicate _fetchPredicate;
  CPManagedObjectContext _context;
  CPFetchRequest _fetchRequest;
  CPMutableArray _observers;
}

- initWithParent:(CPManagedProxy) aParent object:(CPManagedObject) anObject 
{
   _object = anObject;
   _entity = [aParent entity];
   _entityName = [aParent entityName];
   _context = [aParent managedObjectContext];

   _fetchRequest = 	[[CPFetchRequest alloc] initWithEntity:_entity 
														predicate:nil
														sortDescriptors:nil 
														fetchLimit:0];
    
   _observers = [[CPMutableArray alloc] init];
   return self;
}

-(CPString)description {
    return [CPString stringWithFormat: @"<proxy for %@>", _object];
}

- (id) representedObject {
    return _object;
}

- (void)setEntityName:(CPString)name
{
   _entityName = name;
}

- (void)setFetchPredicate:(CPString)name
{
   _fetchPredicate = name;
}

+ (CPArray)fetch
{
	CPLog.info("Fetch en ManagedProxy called");
	
	return [_context executeFetchRequest:_fetchRequest];
  
}

- (CPString)entityName
{
  return _entityName;
}

- (CPEntityDescription) entity 
{
    return _entity;
}

- (CPManagedObjectContext) managedObjectContext 
{
    return _context;
}
+ (CPManagedObjectContext) managedObjectContext 
{
    return _context;
}


+(void)setManagedObjectContext:(CPManagedObjectContext)aContext 
{
    //[[aContext model] name]
    _context = aContext;
    _entity = [CPEntityDescription entityForName:_entityName 
				   inManagedObjectContext: _context];

	_fetchRequest = 	[[CPFetchRequest alloc] initWithEntity:_entity 
															predicate:nil
															sortDescriptors:nil 
															fetchLimit:0];
}

-(id)valueForKey:(CPString)aKey 
{
    if(_object){
		return [_object valueForKey: aKey];
    
	}else{
		return nil;
	}
}


- (void)setValue:(id)aValue forKey:(CPString)aKey 
{
    if([aKey isEqualToString: @"managedObjectContext"])
	{
 		[self setManagedObjectContext: aValue];
	} 
	else if(_object)
	{
		[_object setValue: value forKey: aKey];
	}
}

- (id)objectAtIndex:(unsigned)index 
{
    if(!_context || !_fetchRequest) return nil;
    var object = [[_fetchRequest _resultsInContext: _context] objectAtIndex: index];
    return [[CPManagedProxy alloc] initWithParent: self object: _object];
}

- (unsigned) count {
    var result;
    if(!_context || !_fetchRequest) return 0;
    else result = [_fetchRequest _countInContext: _context];
    CPLog.info(@"%@ being asked about its count and saying %lu; %@ %@\n", self, result,
	  _context, _fetchRequest);
    return result;
}

- (void) addObserver: (CPObject) observer
  toObjectsAtIndexes: (CPIndexSet) indexes
	  forKeyPath: (CPString) keyPath
	     options: (CPKeyValueObservingOptions) options
	     context: (void) context
{
    CPLog.info(@"Proxy for %@ asked to observe by %@ for keypath %@ options 0x%08x\n",
	  _object,
	  observer,
	  keyPath,
	  options);
    var observerInfo = [[_CPManagedProxy_observerInfo alloc] init];
    [observerInfo setObserver: observer];
    [observerInfo setIndexSet: indexes];
    [observerInfo setKeyPath: keyPath];
    [observerInfo setOptions: options];
    [observerInfo setContext: context];
    [_observers addObject: observerInfo];
    [self notifyObserver: observerInfo];
}

- (void) removeObserver:(CPObject) observer
   fromObjectsAtIndexes: (CPIndexSet) indexes
	     forKeyPath: (CPString) keyPath
{
}

- (void) notifyObserver:(_CPManagedProxy_observerInfo) observerInfo 
{
    var change = [CPDictionary dictionary];
    [[observerInfo observer] observeValueForKeyPath: [observerInfo keyPath] ofObject: self change: change context: [observerInfo context]];
}

- (void) _refresh 
{
    CPLog.info(@"%@ about to refresh", self);
	var e =[_observers keyEnumerator];
	var info = [[_CPManagedProxy_observerInfo alloc] init];
	
	while (info =[e nextObject])
	{ 
		[self notifyObserver: info];
	}
    CPLog.info(@"%@ refreshed", self);
}


- (id) objectValueForTableColumn: (CPTableColumn) column 
{
    return [self valueForKey: @"name"];
}


@end

@implementation CPManagedProxy (CPCoder)

- (id)initWithCoder:(CPCoder)aCoder
{
  	self = [super init];

	if(self){
	    _object = nil;
	    _context = nil;
	    _entity = nil;

	    _entityName = [aCoder decodeObjectForKey: @"CPEntityName"];
	    _fetchPredicate=[aCoder decodeObjectForKey: @"CPFetchPredicate"];

	    _fetchRequest = [[CPFetchRequest alloc] init];
	    [_fetchRequest setEntity: _entity];
	    [_fetchRequest setPredicate: _fetchPredicate];

	    _observers = [[CPMutableArray alloc] init];
	    return self;
	   } else {
	    [CPException raise:CPInvalidArgumentException format: @"%@ can not initWithCoder:%@", isa, [aCoder class]];
	    return nil;
	   }
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
  [aCoder encodeObject:_entityName forKey:@"CPEntityName"];
  [aCoder encodeObject:_fetchPredicate forKey:@"CPFetchPredicate"];
}

@end

@implementation _CPManagedProxy_observerInfo : CPObject 
{
    CPObject observer @accessors;
    CPIndexSet indexSet @accessors;
    CPString keyPath @accessors;
    CPKeyValueObservingOptions options @accessors;
    id context @accessors;
}
@end
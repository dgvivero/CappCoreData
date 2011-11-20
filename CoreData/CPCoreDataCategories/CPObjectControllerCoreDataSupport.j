//
//  CPObjectControllerCoreDataSupport.j
//
//  Created by German Vivero on 1.11.2011.
//

@import <Foundation/Foundation.j>
@import <AppKit/CPObjectController.j>
@import "CPManagedProxy.j"


@implementation CPObjectController (CPCoreDataSupport)

- (void)setEntityName:(CPString)name
{
   CPLog.info("ObjectController call entityName");
    [CPManagedProxy setEntityName:name];
}

- (CPManagedObjectContext)managedObjectContext
{
    return [CPManagedProxy managedObjectContext];
}

- (void)setManagedObjectContext:(CPManagedObjectContext)managedObjectContext
{
   CPLog.info("ObjectController call setManagedObjectContext");
    [CPManagedProxy setManagedObjectContext:managedObjectContext];
    
    if ([self automaticallyPreparesContent]) {
        var anArray = [CPManagedProxy fetch];
        [self setContent: anArray];
    }
}

- (CPPredicate)fetchPredicate
{
    CPLog.debug("fetchPredicate in objectController Category");

    return [_managedProxy fetchPredicate];
}
- (void)setFetchPredicate:(CPPredicate)predicate
{
    [_managedProxy serFetchPredicate: predicate];
}

/* subclasses can override this method to customize the fetch request, 
for example to specify fetch limits (passing nil for the fetch request will result in the default fetch request to be used; 
this method will never be invoked with a nil fetch request from within the standard Cocoa frameworks) 
- the merge flag determines whether the controller replaces the entire content with the fetch result 
or merges the existing content with the fetch result
*/
- (BOOL)fetchWithRequest:(CPFetchRequest)fetchRequest merge:(BOOL)merge error:(CPError)error
{
    CPLog.info("ObjectController call fetchWithRequest");
} 

-(void)fetch:(id)sender
{
    CPLog.info("Llamada a fetch");
    var anArray = [CPManagedProxy fetch];
    [self setContent: anArray];

}
- (void)setUsesLazyFetching:(BOOL)enabled
{

}
- (BOOL)usesLazyFetching // defaults to NO. 
{
    return NO
}
- (CPFetchRequest)defaultFetchRequest
{
    CPLog.info("ObjectController called defaultFetchRequest");
    return NO;
}

@end
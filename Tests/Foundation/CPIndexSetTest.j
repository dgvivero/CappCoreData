@import <Foundation/CPIndexSet.j>

function descriptionWithoutEntity(aString)
{
    var descriptionWithEntity = [aString description];
//print(descriptionWithEntity);
    return descriptionWithEntity.substr(descriptionWithEntity.indexOf('>') + 1);
}

@implementation CPIndexSetTest : OJTestCase
{
    CPIndexSet _set;
}

- (void)setUp
{
    _set = [CPIndexSet indexSetWithIndexesInRange:CPMakeRange(10, 10)];
}

- (void)testAddIndexes
{
    var indexSet = [CPIndexSet indexSet];

    // Test no indexes
    [self assert:descriptionWithoutEntity(indexSet) equals:@"(no indexes)"];
    
    // Test adding initial range
    [indexSet addIndexesInRange:CPMakeRange(30,10)];

    [self assert:@"[number of indexes: 10 (in 1 range), indexes: (30-39)]" equals:descriptionWithoutEntity(indexSet)];

    // Test adding range after existing ranges.
    [indexSet addIndexesInRange:CPMakeRange(50,10)];

    [self assert:@"[number of indexes: 20 (in 2 ranges), indexes: (30-39 50-59)]" equals:descriptionWithoutEntity(indexSet)];

    // Test adding range before existing ranges.
    [indexSet addIndexesInRange:CPMakeRange(10,10)];

    [self assert:@"[number of indexes: 30 (in 3 ranges), indexes: (10-19 30-39 50-59)]" equals:descriptionWithoutEntity(indexSet)];

    // Test adding range inbetween existing ranges.
    [indexSet addIndexesInRange:CPMakeRange(45,2)];

    [self assert:@"[number of indexes: 32 (in 4 ranges), indexes: (10-19 30-39 45-46 50-59)]" equals:descriptionWithoutEntity(indexSet)];

    // Test adding single index inbetween existing ranges.
    [indexSet addIndexesInRange:CPMakeRange(23,1)];

    [self assert:@"[number of indexes: 33 (in 5 ranges), indexes: (10-19 23 30-39 45-46 50-59)]" equals:descriptionWithoutEntity(indexSet)];

    // Test adding range inbetween existing ranges that forces a combination
    [indexSet addIndexesInRange:CPMakeRange(47,3)];

    [self assert:@"[number of indexes: 36 (in 4 ranges), indexes: (10-19 23 30-39 45-59)]" equals:descriptionWithoutEntity(indexSet)];

    // Test adding range across ranges forcing a combination
    [indexSet addIndexesInRange:CPMakeRange(35,15)];

    [self assert:@"[number of indexes: 41 (in 3 ranges), indexes: (10-19 23 30-59)]" equals:descriptionWithoutEntity(indexSet)];

    // Test adding range across two empty slots forcing a combination
    [indexSet addIndexesInRange:CPMakeRange(5,70)];

    [self assert:@"[number of indexes: 70 (in 1 range), indexes: (5-74)]" equals:descriptionWithoutEntity(indexSet)];

    // Test adding to extend the beginning of the first range
    [indexSet addIndex:4];

    [self assert:@"[number of indexes: 71 (in 1 range), indexes: (4-74)]" equals:descriptionWithoutEntity(indexSet)];
}

- (void)testRemoveIndexes
{
    var indexSet = [CPIndexSet indexSet];

    // Test no indexes
    [self assert:descriptionWithoutEntity(indexSet) equals:@"(no indexes)"];
    
    // Test adding initial range
    [indexSet addIndexesInRange:CPMakeRange(0, 70)];

    [self assert:@"[number of indexes: 70 (in 1 range), indexes: (0-69)]" equals:descriptionWithoutEntity(indexSet)];

    // Test remove range that is subset of existing range, causing a split.
    [indexSet removeIndexesInRange:CPMakeRange(30, 10)];

    [self assert:@"[number of indexes: 60 (in 2 ranges), indexes: (0-29 40-69)]" equals:descriptionWithoutEntity(indexSet)];

    // Test remove range that is subset of existing range, causing a split.
    [indexSet removeIndexesInRange:CPMakeRange(50, 5)];

    [self assert:@"[number of indexes: 55 (in 3 ranges), indexes: (0-29 40-49 55-69)]" equals:descriptionWithoutEntity(indexSet)];

    // Test remove index that is subset of existing range, causing a split.
    [indexSet removeIndex:57];

    [self assert:@"[number of indexes: 54 (in 4 ranges), indexes: (0-29 40-49 55-56 58-69)]" equals:descriptionWithoutEntity(indexSet)];

    // Test remove range that is an exactly represented in the set.
    [indexSet removeIndexesInRange:CPMakeRange(40, 10)];

    [self assert:@"[number of indexes: 44 (in 3 ranges), indexes: (0-29 55-56 58-69)]" equals:descriptionWithoutEntity(indexSet)];

    // Test remove range that isn't in the set.
    [indexSet removeIndexesInRange:CPMakeRange(35, 3)];

    [self assert:@"[number of indexes: 44 (in 3 ranges), indexes: (0-29 55-56 58-69)]" equals:descriptionWithoutEntity(indexSet)];

    // Test remove range that is partially in a left range.
    [indexSet removeIndexesInRange:CPMakeRange(25, 7)];

    [self assert:@"[number of indexes: 39 (in 3 ranges), indexes: (0-24 55-56 58-69)]" equals:descriptionWithoutEntity(indexSet)];

    // Test remove range that is partially in a left range.
    [indexSet removeIndexesInRange:CPMakeRange(57, 3)];

    [self assert:@"[number of indexes: 37 (in 3 ranges), indexes: (0-24 55-56 60-69)]" equals:descriptionWithoutEntity(indexSet)];

    // Test remove range that is partially in a left and right range.
    [indexSet removeIndexesInRange:CPMakeRange(20, 36)];

    [self assert:@"[number of indexes: 31 (in 3 ranges), indexes: (0-19 56 60-69)]" equals:descriptionWithoutEntity(indexSet)];
    
    // Remove single index that represents an entire range.
    [indexSet removeIndex:56];

    [self assert:@"[number of indexes: 30 (in 2 ranges), indexes: (0-19 60-69)]" equals:descriptionWithoutEntity(indexSet)];
    
    // Remove index set that is subset of existing range, causing a split.
    [indexSet removeIndexes:[CPIndexSet indexSetWithIndexesInRange:CPMakeRange(5, 10)]];

    [self assert:@"[number of indexes: 20 (in 3 ranges), indexes: (0-4 15-19 60-69)]" equals:descriptionWithoutEntity(indexSet)];

    // Remove indexes that are partially in 2 ranges and contains intermediate range.
    [indexSet removeIndexesInRange:CPMakeRange(2, 62)];

    [self assert:@"[number of indexes: 8 (in 2 ranges), indexes: (0-1 64-69)]" equals:descriptionWithoutEntity(indexSet)];

    // Remove indexes that fit exactly in 2 ranges.
    [indexSet removeIndexesInRange:CPMakeRange(0, 70)];

    [self assert:@"(no indexes)" equals:descriptionWithoutEntity(indexSet)];

    indexSet = [CPIndexSet indexSetWithIndexesInRange:CPMakeRange(0, 30)];

    // Remove indexes from left hand of single range
    [indexSet removeIndexesInRange:CPMakeRange(0, 29)];

    [self assert:@"[number of indexes: 1 (in 1 range), indexes: (29)]" equals:descriptionWithoutEntity(indexSet)];

    indexSet = [CPIndexSet indexSetWithIndexesInRange:CPMakeRange(0, 30)];

    // Remove indexes from right hand of single range
    [indexSet removeIndexesInRange:CPMakeRange(1, 29)];

    [self assert:@"[number of indexes: 1 (in 1 range), indexes: (0)]" equals:descriptionWithoutEntity(indexSet)];
}

- (void)testGetIndexes
{
    var indexSet = [CPIndexSet indexSet];

    // Test no indexes
    [self assert:descriptionWithoutEntity(indexSet) equals:@"(no indexes)"];

    // Test adding initial range
    [indexSet addIndexesInRange:CPMakeRange(0, 10)];

    [indexSet addIndexesInRange:CPMakeRange(15, 1)];

    [indexSet addIndexesInRange:CPMakeRange(20, 10)];

    [indexSet addIndexesInRange:CPMakeRange(50, 10)];

    [self assert:@"[number of indexes: 31 (in 4 ranges), indexes: (0-9 15 20-29 50-59)]" equals:descriptionWithoutEntity(indexSet)];

    var array = [];

    [indexSet getIndexes:array maxCount:1000 inIndexRange:nil];

    [self assert:[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 15, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59] equals:array];
}

- (void)testIndexSet:(CPIndexSet)set containsRange:(CPRange)range
{
    [self assertFalse:[set containsIndex:range.location -1]];
    
    for (var i=range.location, max=CPMaxRange(range); i<max; i++)
    {
        [self assertTrue:[set containsIndex:i]];
    }
    
    [self assertFalse:[set containsIndex:i]];
}

- (void)testIndexSet
{
    [self assertNotNull:[CPIndexSet indexSet]];
    [self assert:[[CPIndexSet indexSet] class] equals:[CPIndexSet class]];
}

- (void)testIndexSetWithIndex
{
    [self assertTrue:[[CPIndexSet indexSetWithIndex:1] containsIndex:1]];
    [self assertTrue:[[CPIndexSet indexSetWithIndex:0] containsIndex:0]];
    [self assertFalse:[[CPIndexSet indexSetWithIndex:0] containsIndex:1]];
}

- (void)testIndexSetWithIndexesInRange
{
    var set = [CPIndexSet indexSetWithIndexesInRange:CPMakeRange(0, 7)];
    [self assertNotNull:set];
    [self testIndexSet:set containsRange:CPMakeRange(0, 7)];
}

- (void)testInit
{
    var set = [[CPIndexSet alloc] init];
    [self assertNotNull:set];
    [self assert:[set count] equals:0];
}

- (void)testInitWithIndex
{
    var set = [[CPIndexSet alloc] initWithIndex:234];
    [self assertNotNull:set];
    [self assertTrue:[set containsIndex:234]];
    [self assertFalse:[set containsIndex:5432]];
}

- (void)testInitWithIndexesInRange
{
    var set = [[CPIndexSet alloc] initWithIndexesInRange:CPMakeRange(0, 7)];
    [self assertNotNull:set];
    [self testIndexSet:set containsRange:CPMakeRange(0, 7)];
    [self assertTrue:[set containsIndexesInRange:CPMakeRange(0, 7)]];
    [self assertTrue:[set containsIndexesInRange:CPMakeRange(1, 6)]];
    [self assertFalse:[set containsIndexesInRange:CPMakeRange(2, 6)]];
}

- (void)testInitWithIndexSet
{
    var set1 = [[CPIndexSet alloc] initWithIndexesInRange:CPMakeRange(0, 7)];
    var set = [[CPIndexSet alloc] initWithIndexSet:set1];
    [self assertNotNull:set];
    [self testIndexSet:set containsRange:CPMakeRange(0, 7)];
}

- (void)testIsEqualToIndexSet
{
    var set1 = [CPIndexSet indexSetWithIndex:7];
    var set2 = [CPIndexSet indexSetWithIndex:7];
    var set3 = [CPIndexSet indexSetWithIndexesInRange:CPMakeRange(7, 2)];
    
    [self assertTrue:[set1 isEqualToIndexSet:set2]];
    [self assertTrue:[set1 isEqualToIndexSet:set1]];
    [self assertFalse:[set1 isEqualToIndexSet:set3]];
}

- (void)testCount
{
    var set = [CPIndexSet indexSetWithIndexesInRange:CPMakeRange(7, 2)];
    var set2 = [CPIndexSet indexSetWithIndex:7];

    [self assert:[set2 count] equals:1];
    [self assert:[set count] equals:2];
}

- (void)testFirstIndex
{
    [self assert:[_set firstIndex] equals:10];
    [self assert:[[CPIndexSet indexSet] firstIndex] equals:CPNotFound];
}

- (void)testLastIndex
{
    [self assert:[_set lastIndex] equals:19];
    [self assert:[[CPIndexSet indexSet] lastIndex] equals:CPNotFound];
}
/*
- (void)testAddSpeed
{
    var startTime = [CPDate date];
    
    for (var i = 0; i < 1000; i++)
    {
       [_set addIndex:ROUND(RAND()*100000)];
    }

    print([startTime timeIntervalSinceNow]);
    //[self assertTrue: ABS([startTime timeIntervalSinceNow]) < 2];  
}
*/
- (void)testIndexGreaterThanIndex
{
    [self assert:[_set indexGreaterThanIndex:5] equals:10];
    [self assert:[_set indexGreaterThanIndex:11] equals:12];
    [self assert:[_set indexGreaterThanIndex:19] equals:CPNotFound];
}

- (void)testIndexLessThanIndex
{
    [self assert:[_set indexLessThanIndex:5] equals:CPNotFound];
    [self assert:[_set indexLessThanIndex:11] equals:10];
    [self assert:[_set indexLessThanIndex:20] equals:19];
    [self assert:[_set indexLessThanIndex:222] equals:19];
}

- (void)testIndexGreaterThanOrEqualToIndex
{
    [self assert:[_set indexGreaterThanOrEqualToIndex:5] equals:10];
    [self assert:[_set indexGreaterThanOrEqualToIndex:10] equals:10];
    [self assert:[_set indexGreaterThanOrEqualToIndex:19] equals:19];
    [self assert:[_set indexGreaterThanOrEqualToIndex:20] equals:CPNotFound];
}

- (void)testIndexLessThanOrEqualToIndex
{
    [self assert:[_set indexLessThanOrEqualToIndex:5] equals:CPNotFound];
    [self assert:[_set indexLessThanOrEqualToIndex:10] equals:10];
    [self assert:[_set indexLessThanOrEqualToIndex:19] equals:19];
    [self assert:[_set indexLessThanOrEqualToIndex:20] equals:19];
}

- (void)testContainsIndex
{
    [self assertTrue:[_set containsIndex:10]];
    [self assertTrue:[_set containsIndex:11]];
    [self assertTrue:[_set containsIndex:19]];
    [self assertFalse:[_set containsIndex:9]];
    [self assertFalse:[_set containsIndex:20]];
}

- (void)testContainsIndexesInRange
{
    [self assertTrue:[_set containsIndexesInRange:CPMakeRange(10, 10)]];
    [self assertFalse:[_set containsIndexesInRange:CPMakeRange(10, 0)]];
    [self assertTrue:[_set containsIndexesInRange:CPMakeRange(10, 1)]];
    [self assertTrue:[_set containsIndexesInRange:CPMakeRange(14, 2)]];
    [self assertFalse:[_set containsIndexesInRange:CPMakeRange(10, 11)]];
    [self assertFalse:[_set containsIndexesInRange:CPMakeRange(9, 2)]];
    [self assertFalse:[_set containsIndexesInRange:CPMakeRange(19, 2)]];
}

- (void)testContainsIndexes
{
    [self assertTrue:[_set containsIndexes:_set]];
    [self assertTrue:[_set containsIndexes:[CPIndexSet indexSetWithIndexesInRange:CPMakeRange(10, 1)]]];
    [self assertTrue:[_set containsIndexes:[CPIndexSet indexSetWithIndexesInRange:CPMakeRange(10, 10)]]];
    [self assertTrue:[_set containsIndexes:[CPIndexSet indexSetWithIndexesInRange:CPMakeRange(19, 1)]]];
    [self assertFalse:[_set containsIndexes:[CPIndexSet indexSetWithIndexesInRange:CPMakeRange(10, 11)]]];
    [self assertFalse:[_set containsIndexes:[CPIndexSet indexSetWithIndexesInRange:CPMakeRange(9, 2)]]];
}

- (void)testShiftIndexesStartingAtIndex
{
    var startRange = CPMakeRange(1, 5),
        shiftRange = CPMakeRange(2, 5);
    _set = [CPIndexSet indexSetWithIndexesInRange:startRange];
    
    // positive delta for downward shift
    [_set shiftIndexesStartingAtIndex:1 by:1];
    [self assertTrue:[_set containsIndexes:[CPIndexSet indexSetWithIndexesInRange:shiftRange]]];
    
    // negative delta for downward shift
    [_set shiftIndexesStartingAtIndex:1 by:-1];
    [self assertTrue:[_set containsIndexes:[CPIndexSet indexSetWithIndexesInRange:startRange]]];
}

- (void)tearDown
{
    _set = nil;
}

@end
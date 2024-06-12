# TickLens
[Git Source](https://github.com/KYRDTeam/ilo-contracts/blob/be1379a5058f6506f3a229427893748ee4e5ab65/src/lens/TickLens.sol)

**Inherits:**
[ITickLens](/src/interfaces/ITickLens.sol/interface.ITickLens.md)


## Functions
### getPopulatedTicksInWord

Get all the tick data for the populated ticks from a word of the tick bitmap of a pool


```solidity
function getPopulatedTicksInWord(address pool, int16 tickBitmapIndex)
    public
    view
    override
    returns (PopulatedTick[] memory populatedTicks);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`pool`|`address`|The address of the pool for which to fetch populated tick data|
|`tickBitmapIndex`|`int16`|The index of the word in the tick bitmap for which to parse the bitmap and fetch all the populated ticks|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`populatedTicks`|`PopulatedTick[]`|An array of tick data for the given word in the tick bitmap|



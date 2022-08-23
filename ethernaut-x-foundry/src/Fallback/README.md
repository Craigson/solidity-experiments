# 1. Fallback

**NOTE** - Some code has been slightly altered to work with newer versions of solidity and enable us to test the level with foundry. Any where this has been done an accompanying comment gives context for why this change was made.

**Instructions**

Look carefully at the contract's code below.

You will beat this level if:

you claim ownership of the contract
you reduce its balance to 0

Things that might help:

-   How to send ether when interacting with an ABI
-   How to send ether outside of the ABI
-   Converting to and from wei/ether units (see help() command)
-   Fallback methods

**Original Level**

https://ethernaut.openzeppelin.com/level/0x9CB391dbcD447E645D6Cb55dE6ca23164130D008

## Walkthrough

https://hackernoon.com/ethernaut-lvl-1-walkthrough-how-to-abuse-the-fallback-function-118057b68b56

## Foundry

```
forge test --match-contract FallbackTest -vvvv
```

![alt text](https://github.com/ciaranmcveigh5/ethernaut-x-foundry/blob/main/img/Fallback.png?raw=true)

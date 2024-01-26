# signature

Traces:
  [196331] NFTMarketplaceTest::test_BuyNFTWL()
    ├─ [0] VM::startPrank(seller: [0xDFa97bfe5d2b2E8169b194eAA78Fbb793346B174])
    │   └─ ← ()
    ├─ [78720] NFTMarketplace::listNFT(0, 100)
    │   ├─ [2620] MyNFT::ownerOf(0) [staticcall]
    │   │   └─ ← seller: [0xDFa97bfe5d2b2E8169b194eAA78Fbb793346B174]
    │   ├─ emit NFTListed(tokenId: 0, seller: seller: [0xDFa97bfe5d2b2E8169b194eAA78Fbb793346B174], price: 100)
    │   └─ ← ()
    ├─ [0] VM::stopPrank()
    │   └─ ← ()
    ├─ [0] console::log("admin:", admin: [0xaA10a84CE7d9AE517a52c6d5cA153b369Af99ecF]) [staticcall]
    │   └─ ← ()
    ├─ [0] console::log("privateKey:", 109570584058932911814882329213916337771104575516230068759881284754962024964824 [1.095e77]) [staticcall]
    │   └─ ← ()
    ├─ [0] console::log("buyerAddress:", buyer: [0x0fF93eDfa7FB7Ad5E962E4C0EdB9207C03a0fe02]) [staticcall]
    │   └─ ← ()
    ├─ [0] VM::sign(109570584058932911814882329213916337771104575516230068759881284754962024964824 [1.095e77], 0xf7487ff19e6a61e6c4d45beacb6ceece7a93b54a9c79740a485d4a1a167bff4e) [staticcall]
    │   └─ ← 28, 0x0bd020d0a6fc0ff0f69097c0814a31b0dbea9ceda2eb9c17941069534753b54f, 0x370173fb5a9881795d108ce5bd75a082277683de436e9238b13c61988a260190
    ├─ [0] VM::startPrank(buyer: [0x0fF93eDfa7FB7Ad5E962E4C0EdB9207C03a0fe02])
    │   └─ ← ()
    ├─ [104686] NFTMarketplace::buyNFTWhitelist(0, 100, 0x0bd020d0a6fc0ff0f69097c0814a31b0dbea9ceda2eb9c17941069534753b54f370173fb5a9881795d108ce5bd75a082277683de436e9238b13c61988a2601901c)
    │   ├─ [3000] PRECOMPILES::ecrecover(0xf7487ff19e6a61e6c4d45beacb6ceece7a93b54a9c79740a485d4a1a167bff4e, 28, 5343172005027371098746727881210641631176459699551840330511682219257336411471, 24879773996461767594675866166587900802490863362308131816235858893967362228624) [staticcall]
    │   │   └─ ← 0x000000000000000000000000aa10a84ce7d9ae517a52c6d5ca153b369af99ecf
    │   ├─ [0] console::log("recoveredSigner", admin: [0xaA10a84CE7d9AE517a52c6d5cA153b369Af99ecF]) [staticcall]
    │   │   └─ ← ()
    │   ├─ [0] console::log("signer", admin: [0xaA10a84CE7d9AE517a52c6d5cA153b369Af99ecF]) [staticcall]
    │   │   └─ ← ()
    │   ├─ [35640] MyToken::transferFrom(buyer: [0x0fF93eDfa7FB7Ad5E962E4C0EdB9207C03a0fe02], seller: [0xDFa97bfe5d2b2E8169b194eAA78Fbb793346B174], 100)
    │   │   ├─ emit Transfer(from: buyer: [0x0fF93eDfa7FB7Ad5E962E4C0EdB9207C03a0fe02], to: seller: [0xDFa97bfe5d2b2E8169b194eAA78Fbb793346B174], value: 100)
    │   │   └─ ← true
    │   ├─ [41553] MyNFT::safeTransferFrom(seller: [0xDFa97bfe5d2b2E8169b194eAA78Fbb793346B174], buyer: [0x0fF93eDfa7FB7Ad5E962E4C0EdB9207C03a0fe02], 0)
    │   │   ├─ emit Transfer(from: seller: [0xDFa97bfe5d2b2E8169b194eAA78Fbb793346B174], to: buyer: [0x0fF93eDfa7FB7Ad5E962E4C0EdB9207C03a0fe02], tokenId: 0)
    │   │   └─ ← ()
    │   ├─ emit NFTSold(tokenId: 0, buyer: buyer: [0x0fF93eDfa7FB7Ad5E962E4C0EdB9207C03a0fe02], price: 100)
    │   └─ ← ()
    ├─ [563] MyToken::balanceOf(seller: [0xDFa97bfe5d2b2E8169b194eAA78Fbb793346B174]) [staticcall]
    │   └─ ← 100
    ├─ [0] console::log("token.balanceOf(sellerAddress)==", 100) [staticcall]
    │   └─ ← ()
    ├─ [563] MyToken::balanceOf(buyer: [0x0fF93eDfa7FB7Ad5E962E4C0EdB9207C03a0fe02]) [staticcall]
    │   └─ ← 9900
    ├─ [0] console::log("token.balanceOf(buyerAddress)==", 9900) [staticcall]
    │   └─ ← ()
    ├─ [0] VM::stopPrank()
    │   └─ ← ()
    ├─ [563] MyToken::balanceOf(seller: [0xDFa97bfe5d2b2E8169b194eAA78Fbb793346B174]) [staticcall]
    │   └─ ← 100
    ├─ [563] MyToken::balanceOf(buyer: [0x0fF93eDfa7FB7Ad5E962E4C0EdB9207C03a0fe02]) [staticcall]
    │   └─ ← 9900
    └─ ← ()

Test result: ok. 1 passed; 0 failed; 0 skipped; finished in 3.92ms
| src/MyNFT.sol:MyNFT contract |                 |       |        |       |         |
|------------------------------|-----------------|-------|--------|-------|---------|
| Deployment Cost              | Deployment Size |       |        |       |         |
| 1105953                      | 5928            |       |        |       |         |
| Function Name                | min             | avg   | median | max   | # calls |
| approve                      | 25119           | 25119 | 25119  | 25119 | 1       |
| ownerOf                      | 2620            | 2620  | 2620   | 2620  | 1       |
| safeMint                     | 96341           | 96341 | 96341  | 96341 | 1       |
| safeTransferFrom             | 41553           | 41553 | 41553  | 41553 | 1       |


| src/MyToken.sol:MyToken contract |                 |       |        |       |         |
|----------------------------------|-----------------|-------|--------|-------|---------|
| Deployment Cost                  | Deployment Size |       |        |       |         |
| 689130                           | 3843            |       |        |       |         |
| Function Name                    | min             | avg   | median | max   | # calls |
| approve                          | 24762           | 24762 | 24762  | 24762 | 1       |
| balanceOf                        | 563             | 563   | 563    | 563   | 4       |
| mint                             | 47042           | 47042 | 47042  | 47042 | 1       |
| transferFrom                     | 35640           | 35640 | 35640  | 35640 | 1       |


| src/NFTMarketplace.sol:NFTMarketplace contract |                 |        |        |        |         |
|------------------------------------------------|-----------------|--------|--------|--------|---------|
| Deployment Cost                                | Deployment Size |        |        |        |         |
| 1446394                                        | 7445            |        |        |        |         |
| Function Name                                  | min             | avg    | median | max    | # calls |
| buyNFTWhitelist                                | 104686          | 104686 | 104686 | 104686 | 1       |
| listNFT                                        | 78720           | 78720  | 78720  | 78720  | 1       |



 
Ran 1 test suites: 1 tests passed, 0 failed, 0 skipped (1 total tests)

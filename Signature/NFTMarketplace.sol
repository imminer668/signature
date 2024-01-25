// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


contract NFTMarketplace is Ownable {
    IERC20 public erc20Contract;
    IERC721 public nftContract;
    using SafeERC20 for IERC20;
    address public signer;
    event NFTListed(
        uint256 indexed tokenId,
        address indexed seller,
        uint256 price
    );
    event NFTSold(
        uint256 indexed tokenId,
        address indexed buyer,
        uint256 price
    );
    //error deposit eth too few tips
    error AmountTooLow(uint256 eth);

    event WthdrawEthEvent(address indexed _address, uint256 amount);
    error invalidAddress(address _owner);
    error transferFailed(address _address);

    constructor(
        address _owner,
        address token,
        address nft
    ) Ownable(_owner) {
        signer=_owner;
        erc20Contract = IERC20(token);
        nftContract = IERC721(nft);

        domain = EIP712Domain({
            name: "SignatureTest",
            version: "1.0",
            verifyingContract: address(this),
            salt: bytes32(0)
        });
    }

    struct Listing {
        uint256 tokenId; //id
        address seller; //拥有者
        uint256 price; // 以wei为单位
        bool active; //是否活跃
    }
    mapping(uint256 => Listing) public lists;

    //白名单地址
    mapping(address => bool) public whitelist;


    struct EIP712Domain {
        string name;
        string version;
        address verifyingContract;
        bytes32 salt;
    }

    bytes32 private constant EIP712DOMAIN_TYPEHASH =
        keccak256(
            "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
        );

    bytes32 private constant VERIFY_TYPEHASH =
        keccak256("Verify(address to)");

    EIP712Domain public domain;

    function getDomainSeparator() private view returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    EIP712DOMAIN_TYPEHASH,
                    keccak256(bytes(domain.name)),
                    keccak256(bytes(domain.version)),
                    domain.verifyingContract,
                    domain.salt
                )
            );
    }

function verifySignature(
        address to,
        bytes memory signature
    ) private view returns (bool) {
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                getDomainSeparator(),
                keccak256(abi.encode(VERIFY_TYPEHASH, to))
            )
        );
        address recoveredSigner = recoverSigner(digest, signature);
        
        return recoveredSigner == signer;
    }


    function addToWhitelist(address account) external {
        require(msg.sender == signer, "Only signer can add to whitelist");
        whitelist[account] = true;
    }

    function removeFromWhitelist(address account) external {
        require(msg.sender == signer, "Only signer can remove from whitelist");
        whitelist[account] = false;
    }

    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x01", hash));
    }

    function recoverSigner(bytes32 digest, bytes memory signature) private pure returns (address) {
        require(signature.length == 65, "Invalid signature length");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }

        if (v < 27) {
            v += 27;
        }

        require(v == 27 || v == 28, "Invalid signature v");

        return ecrecover(digest, v, r, s);
    }




    //上架
    function listNFT(uint256 _tokenId, uint256 _price) public {
        require(
            nftContract.ownerOf(_tokenId) == msg.sender,
            "You are not the owner of this NFT"
        );
        //require(msg.value >= listingFee, "Insufficient listing fee");
        lists[_tokenId] = Listing({
            tokenId: _tokenId,
            seller: msg.sender,
            price: _price,
            active: true
        });

        emit NFTListed(_tokenId, msg.sender, _price);
    }

    function buyNFTWhitelist(uint256 _tokenId, uint256 _price, bytes memory signature) public {
        //bytes32 message = prefixed(keccak256(abi.encodePacked(msg.sender)));
        require(verifySignature(msg.sender, signature), "Invalid signature");
        //require(whitelist[msg.sender], "Unauthorized");
        Listing storage listing = lists[_tokenId];
        require(listing.active, "Listing is not active");
        require(_price >= listing.price, "Incorrect payment amount");
        erc20Contract.safeTransferFrom(msg.sender, listing.seller, _price);
        nftContract.safeTransferFrom(listing.seller, msg.sender, listing.tokenId);
        listing.active = false;

        emit NFTSold(listing.tokenId, msg.sender, listing.price);
    }
    function buyNFT(uint256 _tokenId, uint256 _price) public {
        Listing storage listing = lists[_tokenId];
        require(listing.active, "Listing is not active");
        require(_price >= listing.price, "Incorrect payment amount");
        erc20Contract.safeTransferFrom(msg.sender, listing.seller, _price);
        nftContract.safeTransferFrom(listing.seller, msg.sender, listing.tokenId);
        listing.active = false;

        emit NFTSold(listing.tokenId, msg.sender, listing.price);
    }
    function getListByTokenID(uint256 _tokenId) view public returns(uint256){
        return lists[_tokenId].tokenId;
    }

    function withdrawEth(address payable _recipient, uint256 _amount)
        public
        onlyOwner
    {
        if (_recipient == address(0)) revert invalidAddress(address(0));
        if (_amount == 0 || _amount > address(this).balance)
            revert AmountTooLow(_amount);

        (bool success, ) = _recipient.call{value: _amount}("");
        if (!success) revert transferFailed(_recipient);
        emit WthdrawEthEvent(_recipient, _amount);
    }

    function buyNFTForContract(
        address buyer,        
        uint256 _price,
        uint256 _tokenId
    ) public {
        Listing storage listing = lists[_tokenId];
        require(listing.active, "Listing is not active");
        require(_price >= listing.price, "Incorrect payment amount");
        erc20Contract.safeTransferFrom(buyer, listing.seller, _price);
        nftContract.safeTransferFrom(listing.seller, buyer, listing.tokenId);
        listing.active = false;

        emit NFTSold(listing.tokenId, buyer, listing.price);
    }

    /*function tokensReceived(
        address buyer,
        uint256 tokenId,
        uint256 price
    ) public returns (bool) {
        if (IERC20(msg.sender) == erc20Contract) {
            //buyNFT(tokenId, price);
            buyNFTForContract(buyer,tokenId,price);
            return true;
        } else {
            return false;
        }
    }*/

    function tokensReceived(
        address from,
        address to,
        uint256 amount,
        bytes memory data
    ) public returns (bool) {
        if (IERC20(msg.sender) == erc20Contract) {
            //buyNFT(tokenId, price);
            
            buyNFTForContract(from, amount, abi.decode(data,(uint256)));
            return true;
        } else {
            return false;
        }
    }

    /*function bytesToUint(bytes memory b) internal pure returns (uint256) {
        uint256 number;
        for (uint256 i = 0; i < b.length; i++) {
            number = number + uint8(b[i]) * (2**(8 * (b.length - (i + 1))));
        }
        return number;
    }*/

    function read(bytes32 slot) external  view returns(bytes32 data){
        assembly {
            data := sload(slot) // load from store    
        }
 }
 function write(bytes32 slot,uint256 value) external {
        assembly{
            sstore(slot,value)
        }
 }


//这里用了Ownable，so...changeSigner
 function getSigner() external view returns (address) {
        address result;
        assembly {
            result := sload(signer.slot)
        }
        return result;
    }

    function changeSigner(address newSigner) external onlyOwner{
        assembly {
            sstore(signer.slot, newSigner)
        }
    }



    receive() external payable {}
}

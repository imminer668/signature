// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/Clones.sol";

//import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function mint(address account, uint256 value) external;

    function initialize(string memory name_, string memory symbol_) external;

    function getName() external view returns (string memory);

    function getSymbol() external view returns (string memory);
}

contract InscriptionTokenProxyFactory {
    IERC20 public icToken;
    using Clones for address;

    struct tokenData {
        uint256 totalSupply; //
        uint256 perMint; //
    }
    mapping(address => tokenData) public tokens;

    event ProxyCreated(address proxy);

    address public tokenTemp;

    constructor(address temp){
            tokenTemp=temp;
    }


    function createProxy(address implementation) private returns (address) {
        address proxy = implementation.clone();
        icToken = IERC20(proxy);
        emit ProxyCreated(proxy);
        //IERC20(proxy).getName();
        return proxy;
    }

    function deployInscription(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply,
        uint256 _perMint
    ) public {
        createProxy(tokenTemp);
        icToken.initialize(_name, _symbol);
        tokens[address(icToken)] = tokenData({
            totalSupply: _totalSupply,
            perMint: _perMint
        });
    }

    function mintInscription(address tokenAddr) public {
        //当前erc20
        IERC20 _token = IERC20(tokenAddr);
        require(_token.balanceOf(msg.sender) == 0, "you have mint it");
        //初始化记录的erc20
        tokenData storage token = tokens[tokenAddr];
        require(token.totalSupply > _token.totalSupply(), "finished mint");
        _token.mint(msg.sender, token.perMint);
    }
}

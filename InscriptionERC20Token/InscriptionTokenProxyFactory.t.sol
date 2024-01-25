// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {InscriptionTokenProxyFactory} from "../src/InscriptionTokenProxyFactory.sol";
import {MyERC20} from "../src/MyERC20Inscription.sol";

contract InscriptionTokenProxyFactoryTest is Test {
    
    InscriptionTokenProxyFactory public factory;
    address admin = makeAddr("admin");
    MyERC20 public token;
    MyERC20 public ctoken;
    
    

    function setUp() public {
        //管理员身份先部署以及铸造基本
        vm.startPrank(admin);
        token=new MyERC20(admin,"qq","qq",10000,0);      
        factory = new InscriptionTokenProxyFactory(address(token));  
        //ctoken=MyERC20(factory.createProxy(address(token)));
        vm.stopPrank();
        
    }

    function testFactoryDeployInscription() public{
        factory.deployInscription("bb","bb",10000,10);  
        //console.log(ctoken.name);     
    }

    

 



}

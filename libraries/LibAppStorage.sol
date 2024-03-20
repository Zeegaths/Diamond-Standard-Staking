pragma solidity ^0.8.0;

library LibAppStorage {
    struct Staking{        
        address stakeToken;
        address rewardToken;
        uint totalSupply;
        uint duration;
        mapping(address => uint) balanceOf;
        mapping(address => uint) stakeTime;
        mapping(address => uint) rewards;  
        
    }   

    struct ERC20 {
        mapping(address => uint256)  _balances;

        mapping(address => mapping(address => uint256))  _allowances;

        uint256  _totalSupply;

        string  _name;

        string  _symbol;

        uint8 _decimal;
    }
}
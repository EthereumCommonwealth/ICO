pragma solidity ^0.4.15;

import './SafeMath.sol';

contract CoinvestToken {
    function transfer(address _to, uint256 _amount);
}

contract ICO {
    
    event Buy(address indexed _owner, uint256 indexed _amount);
    
    address public owner; // << Replace with address
    address public token_address; // << Replace with token contract address
    CoinvestToken token = CoinvestToken(token_address);
    
    uint256 public price = 100; // Amount of tokens to be sent per each WEI(ETH) contributed.
    
    uint256 public start_block = block.number;
    uint256 public end_block = block.number + 172800;
    
    function() payable {
        assert(block.number < end_block && block.number > start_block);
        token.transfer(msg.sender, (msg.value * price));
        Buy(msg.sender, msg.value);
    }
    
    function tokenFallback(address, uint, bytes)
    {
        assert(msg.sender == token_address);
    }
    
    function set_timeframes(uint256 _start_block, uint256 _end_block) only_owner
    {
        start_block = _start_block;
        end_block = _end_block;
    }
    
    function adjust_price(uint256 _price) only_owner
    {
        price = _price;
    }
    
    function withdraw() only_owner
    {
        owner.send(this.balance);
    }
    
    
    modifier only_owner
    {
        if(msg.sender != owner)
        {
            revert();
        }
        _;
    }
}

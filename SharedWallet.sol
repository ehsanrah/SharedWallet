pragma solidity ^0.8.0;
//SPDX-License-Identifier: UNLICENSED
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract allowance is Ownable {
    mapping(address => uint) public allowance;
    function addAllowence(address _addr, uint _amount) external onlyOwner() {
        allowance[_addr] = _amount;
    }
    modifier OwnerOrAllowed (uint _amount) {
        require(owner() == msg.sender|| allowance[msg.sender] >= _amount,"You are not allowed!" );
        _;
    }
    function reduceAllowance(address _who, uint _amount) internal{
        allowance[_who] -= _amount;
    }
}
contract SharedWallet is allowance {
    
    function withdrawMoney(address payable _to, uint _amount) public OwnerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "There is not enough funds stored in the smart contract");
        _to.transfer(_amount);
        if(owner() != msg.sender){
            reduceAllowance(msg.sender, _amount);
        }
        
    }
    fallback () external payable {

    }
}

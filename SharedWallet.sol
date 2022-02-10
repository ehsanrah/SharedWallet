pragma solidity ^0.8.0;
//SPDX-License-Identifier: UNLICENSED
import "./Allowance.sol";
contract SimpleWallet is allowance { 
    event MoneySent(address indexed _beneficiary, uint _amount);    
    event MoneyRecieved (address _from, uint _amount);
    function withdrawMoney(address payable _to, uint _amount) public OwnerOrAllowed(_amount) {
        emit MoneySent(_to, _amount);
        require(_amount <= address(this).balance, "There is not enough funds stored in the smart contract");
        _to.transfer(_amount);
        if(owner() != msg.sender){
            reduceAllowance(msg.sender, _amount);
        }   
    }
    function renounceOwnership() public override onlyOwner() {
        revert("You can't do this!");
    }
    fallback () external payable {
        emit MoneyRecieved(msg.sender, msg.value);
    }
}

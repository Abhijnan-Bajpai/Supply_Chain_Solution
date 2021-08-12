// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

contract ItemManager {
    
    enum SupplyChainSteps{Created, Paid, Delivered}
    
    struct S_item {
        ItemManager.SupplyChainSteps _step;
        string _identifier;
        uint _priceInWei;
    }
    
    mapping(uint => S_item) public items;
    uint index;
    
    event SupplyChainStep(uint _index, uint step);
    
    function createItem(string memory _identifier, uint _priceInWei) public {
        items[index]._priceInWei = _priceInWei;
        items[index]._identifier = _identifier;
        items[index]._step = SupplyChainSteps.Created;
        emit SupplyChainStep(index, uint(items[index]._step));
        index++;
    }
    
    function triggerPayment(uint _index) public payable {
        require(items[_index]._priceInWei <= msg.value, "Not fully paid");
        require(items[_index]._step == SupplyChainSteps.Created, "Item further in supply chain");
        items[_index]._step = SupplyChainSteps.Paid;
        emit SupplyChainStep(_index, uint(items[_index]._step));
    }
    
    function triggerDelivery(uint _index) public {
        require(items[_index]._step == SupplyChainSteps.Paid, "Item further in supply chain");
        items[_index]._step = SupplyChainSteps.Delivered;
        emit SupplyChainStep(_index, uint(items[_index]._step));
    }
}
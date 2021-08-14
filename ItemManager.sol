// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

contract ItemManager {
    
    // Saves the present state of each item in the supply chain
    enum SupplyChainSteps{Created, Paid, Delivered}
     
    // An object which defines an item in the supply chain
    struct S_item {
        ItemManager.SupplyChainSteps _step;
        string _identifier;
        uint _priceInWei;
    }
    
    // A mapping of all objects in the supply chain for easier access and keeping note of history
    mapping(uint => S_item) public items;
    uint index;
    
    // Emitting an event on the state change of an object
    event SupplyChainStep(uint _index, uint step);
    
    // Creating a new object by saving all the parameters of the item object
    function createItem(string memory _identifier, uint _priceInWei) public {
        items[index]._priceInWei = _priceInWei;
        items[index]._identifier = _identifier;
        items[index]._step = SupplyChainSteps.Created;
        emit SupplyChainStep(index, uint(items[index]._step));
        index++;
    }
    
    // Triggering payment when the given conditions satisfy
    function triggerPayment(uint _index) public payable {
        require(items[_index]._priceInWei <= msg.value, "Not fully paid");
        require(items[_index]._step == SupplyChainSteps.Created, "Item further in supply chain");
        items[_index]._step = SupplyChainSteps.Paid;
        emit SupplyChainStep(_index, uint(items[_index]._step));
    }
    
    // Triggering delivery when the given conditions satisfy
    function triggerDelivery(uint _index) public {
        require(items[_index]._step == SupplyChainSteps.Paid, "Item further in supply chain");
        items[_index]._step = SupplyChainSteps.Delivered;
        emit SupplyChainStep(_index, uint(items[_index]._step));
    }
}
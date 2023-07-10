// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract EventContract{
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketRemaining;
        uint ticketCount;
    }

    mapping(uint=>Event)public events;
    mapping(address=>mapping(uint=>uint))public tickets;

    uint public nextId;
    function createEvent(string memory name,uint date,uint price,uint ticketCount) external{
        require(date>block.timestamp,"You can only organise event for future only");
        require(ticketCount>0,"You should have ticket available for event");
        events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextId++;
    }

    function buyTicket(uint id,uint quantity)external payable{
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date>block.timestamp,"Event already occured");
        Event storage _event = events[id];
        require(msg.value==_event.price*quantity,"Ether is not enough");
        require(_event.ticketRemaining>=quantity,"Not enough tickets available");
        _event.ticketRemaining-=quantity;
        tickets[msg.sender][id]+=quantity;
    }

    function transferTickets(uint id,uint quantity,address to)external{
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date>=block.timestamp,"Event already occured");
        require(tickets[msg.sender][id]>=quantity,"You don't have enough tickets for this event");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }

}
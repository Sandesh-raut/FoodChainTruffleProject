// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FoodChain {
    enum Quality { Pending, Pass, Fail }

    struct LabTest {
        uint date;
        Quality quality;
        string reportHash;
    }

    struct Event {
        string description;
        uint timestamp;
        uint blockNumber;
    }

    struct Batch {
        uint batchId;
        uint[] cropIds;
        Quality overallQuality;
    }

    struct Crop {
        uint cropId;
        string seedType;
        address owner;
        address currentHolder;
        string origin;
        uint sowingDate;
        string growthConditions;
        LabTest[] labTests;
        Event[] supplyChainEvents;
        uint ripeningDate;
        uint harvestDate;
        Quality overallQuality;
        uint batchId;
    }

    mapping(uint => Crop) public crops;
    mapping(uint => Batch) public batches;
    uint public cropCount = 0;
    uint public batchCount = 0;

    event SeedRegistered(uint cropId, address owner);
    event LabTestAdded(uint cropId, uint testDate);
    event OwnershipTransferred(uint cropId, address previousOwner, address newOwner);
    event SupplyChainEventAdded(uint cropId, string description, uint timestamp, uint blockNumber);
    event PaymentReceived(uint cropId, address payer, uint amount);

    function registerSeed(string memory _seedType, string memory _origin) public payable {
        require(msg.value > 0, "Registration requires a payment.");
        Crop memory newCrop;
        newCrop.cropId = cropCount;
        newCrop.seedType = _seedType;
        newCrop.owner = msg.sender;
        newCrop.currentHolder = msg.sender;
        newCrop.origin = _origin;
        newCrop.sowingDate = block.timestamp;
        newCrop.overallQuality = Quality.Pending;
        newCrop.batchId = batchCount;

        crops[cropCount] = newCrop;
        emit SeedRegistered(cropCount, msg.sender);
        cropCount++;

        if (batches[batchCount].batchId == 0) {
            batches[batchCount].batchId = batchCount;
        }
        batches[batchCount].cropIds.push(newCrop.cropId);
    }

    function addLabTest(uint _cropId, string memory _reportHash, Quality _quality) public {
        require(_cropId < cropCount, "Crop does not exist.");
        require(msg.sender == crops[_cropId].currentHolder, "Only the current holder can add a lab test.");

        LabTest memory newTest;
        newTest.date = block.timestamp;
        newTest.reportHash = _reportHash;
        newTest.quality = _quality;

        crops[_cropId].labTests.push(newTest);
        emit LabTestAdded(_cropId, newTest.date);

        if (_quality == Quality.Fail) {
            crops[_cropId].overallQuality = Quality.Fail;
        }
    }

    function transferOwnership(uint _cropId, address _newOwner) public {
        require(_cropId < cropCount, "Crop does not exist.");
        require(msg.sender == crops[_cropId].currentHolder, "Only the current holder can transfer ownership.");

        address previousOwner = crops[_cropId].currentHolder;
        crops[_cropId].currentHolder = _newOwner;

        emit OwnershipTransferred(_cropId, previousOwner, _newOwner);
    }

    function addSupplyChainEvent(uint _cropId, string memory _description) public {
        require(_cropId < cropCount, "Crop does not exist.");
        require(msg.sender == crops[_cropId].currentHolder, "Only the current holder can add a supply chain event.");

        Event memory newEvent;
        newEvent.description = _description;
        newEvent.timestamp = block.timestamp;
        newEvent.blockNumber = block.number;

        crops[_cropId].supplyChainEvents.push(newEvent);
        emit SupplyChainEventAdded(_cropId, _description, newEvent.timestamp, newEvent.blockNumber);
    }

    function receivePayment(uint _cropId) public payable {
        require(_cropId < cropCount, "Crop does not exist.");
        require(msg.value > 0, "Payment must be greater than 0.");

        address previousOwner = crops[_cropId].currentHolder;
        address currentOwner = msg.sender;

        payable(currentOwner).transfer(msg.value);

        emit PaymentReceived(_cropId, currentOwner, msg.value);

        crops[_cropId].currentHolder = currentOwner;
        emit OwnershipTransferred(_cropId, previousOwner, currentOwner);
    }
}

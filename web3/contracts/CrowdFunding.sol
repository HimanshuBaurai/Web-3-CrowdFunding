// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    } // struct of campaign

    mapping(uint256 => Campaign) public campaigns; //mapping of campaigns

    uint256 public numberOfCampaigns = 0; // number of campaigns

    //Creating a new Campaign
    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns]; //Array of Campaigns

        require(
            campaign.deadline < block.timestamp,
            "The deadline should be a date in the future."
        ); //check to see is everyThing is ok, code doesnt proceed if this is not satisfied

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns - 1; //index of newly created campaign
    }

    //Donating to Campaign, payable is a special keyword denoting we would be sending some cryptoCurrency through this function
    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value; //something we send from frontend

        Campaign storage campaign = campaigns[_id]; //accessing campaign

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if (sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    //get campaign donators and their donations, view means it only returns some data and doesnt change anything
    function getDonators(
        uint256 _id
    ) public view returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    //returns all campaigns
    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns); // array of campaigns

        for (uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i]; // accessing campaign

            allCampaigns[i] = item; // adding campaign to array
        }

        return allCampaigns; // returning array
    }
}

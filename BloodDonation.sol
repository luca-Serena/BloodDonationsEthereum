pragma solidity >=0.4.22 <0.6.0;

contract BloodDonation{
    
    struct Donor{
        string blood;
        address donorAddress;
        uint token;
    }
    
    struct Hospital {
        mapping (string => uint)  availability;
        mapping (uint => address) schedule;
        string name;
    }

    struct Donation {
        uint256 time;
        Donor giver;
        Hospital hosp;
    }

    Hospital [] hospitals;
    Donor [] donors; 
    Donation [] donations;
    string [8] bloodTypes = ["A+", "A-", "B+", "B-", "AB+", "AB-", "0+", "0-"];
}

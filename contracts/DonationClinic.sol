pragma solidity >=0.4.22 <0.6.0;

contract DonationClinic {
    
    struct Donor{
        string blood;
        address donorAddress;
        uint token;
        bool isBooked;
    }
    
    struct Blood{
         string name;
         uint avail;
    }

    struct Reservation {
        uint256 time;
        Donor giver;
    }

    Blood [8] public bloodArray;
    Donor [] public donors;
    Reservation []  reservations;
    string [8] bloodTypes = ["A+", "A-", "B+", "B-", "AB+", "AB-", "0+", "0-"];
    
    constructor () public {
        for (uint i =0; i < bloodTypes.length; i++ ){
            bloodArray[i].name = bloodTypes[i];
            bloodArray [i].avail = 0;
        }
    }
    
    function collect(address addr, uint _ml) public{
        uint index = findDonor (addr);
        require (index < 1000);
        uint reservationIndex = findReservation(addr);
        require (donors[index].isBooked==true);
        uint bloodIndex = getIndex(donors[index].blood);
        bloodArray[bloodIndex].avail += _ml;
        donors[index].token += 1;
        donors[index].isBooked = false;
        reservations[reservationIndex].time = now;
    }
    
    function dispense (string memory blood, uint ml) public noUnderZero (blood, ml){
        uint bloodInd = getIndex (blood);
        bloodArray[bloodInd].avail -=ml;
    }
    
    
    function join (string memory blood) public realBlood(blood){
        uint i = findDonor(msg.sender);
        require (i > 1000);
        donors.push(Donor(blood,msg.sender,0,false));
    }
    
    function book ()  public {
        uint donorIndex = findDonor(msg.sender);
        require (donorIndex < 1000);
        require (donors[donorIndex].isBooked==false);
        reservations.push(Reservation(0, donors[donorIndex]));
        donors[donorIndex].isBooked = true;
    }

    function getDonorsLength() view public returns(uint){
       return donors.length;
    }

    function getTokens (address addr) view public returns (int){
        uint donorIndex = findDonor (addr);
        if (donorIndex > 1000) return -1;
        return int (donors[donorIndex].token);
    }

    modifier noUnderZero (string memory blood, uint amount){
        uint ind = getIndex(blood);
        require (bloodArray[ind].avail >= amount); _;
    }
    
    modifier realBlood (string memory bloodType){ //because it's not allowed to have enum as key of a map
        bytes memory blood = bytes(bloodType);
        require (keccak256(blood) == keccak256('A+') || keccak256(blood) == keccak256("AB+") ||
        keccak256(blood) == keccak256("B+") || keccak256(blood) == keccak256("0+") ||
        keccak256(blood) == keccak256("A-") ||keccak256(blood) == keccak256("AB-") ||
        keccak256(blood) == keccak256("B-") ||keccak256(blood) == keccak256("0-")); 
        _;
    }


    function findDonor (address _name) view private returns(uint){
        for (uint i=0; i < donors.length; i++){
            if (_name == donors[i].donorAddress){
                return i;
            }
        }
        return 1001 ;
    }
    
    function findReservation (address _address) view private returns(uint){
        for (uint i=reservations.length - 1; i >= 0; i--){
            if (_address == reservations[i].giver.donorAddress){
                return i;
            }
        }
        return 1001 ;
    }
    
    function getIndex (string memory blood) private view returns(uint){
        bytes memory b = bytes (blood);
        for (uint i=0; i <8; i++){
            bytes memory temp = bytes (bloodArray[i].name);
            if (keccak256(temp)== keccak256(b)){
                return i;
            }
        }  
        return 1000;
    }
}

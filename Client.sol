pragma solidity >=0.4.22 <0.6.0;
import "./BloodDonation.sol";

contract Client is BloodDonation{
    
    address public addr;

    constructor (string memory blood) payable public realBlood(blood) {
        donors.push (Donor(blood, msg.sender, 0 ));
        addr = msg.sender;
    }
    
   function findHospital (string memory _name) view private returns(uint){
        bytes memory nameHosp = bytes (_name);
        for (uint i=0; i < hospitals.length; i++){
            bytes memory temp = bytes (hospitals[i].name);
            if (keccak256(temp)== keccak256(nameHosp)){
                return i;
            }
        }
        return 1001 ;
    }
    
    function book (uint8 day, uint8 hour, string memory _name) payable public {
        uint index = findHospital (_name);
    //    bytes memory temp = bytes (hosp.name);
        require (index < 1000);
        uint roundId = day * 96 + hour; //assuming a blood sample per hour
        hospitals[index].schedule[roundId] = msg.sender;
    }
    
        
    modifier realBlood (string memory bloodType){ //because it's not allowed to have enum as key of a map
        bytes memory blood = bytes(bloodType);
        require (keccak256(blood) == keccak256('f') || keccak256(blood) == keccak256("AB+") ||
        keccak256(blood) == keccak256("B+") || keccak256(blood) == keccak256("0+") ||
        keccak256(blood) == keccak256("A-") ||keccak256(blood) == keccak256("AB-") ||
        keccak256(blood) == keccak256("B-") ||keccak256(blood) == keccak256("0-")); 
        _;
    }
    
    
}

pragma experimental ABIEncoderV2;
pragma solidity >= 0.4.25;
import "./BloodDonation.sol";

contract Clinic is BloodDonation{
    
    Hospital hosp;
    
    constructor (string memory _name) payable public isNotAnExistingHospital(_name){
        hosp.name = _name;
        for (uint i =0; i < bloodTypes.length; i++ ){
            hosp.availability[bloodTypes[i]] = 0;
        }
        hospitals.push (hosp);
    }
    
    modifier isNotAnExistingHospital (string memory _name){
        bytes memory nameHosp = bytes (_name);
        for (uint i=0; i < hospitals.length; i++){
            bytes memory temp = bytes (hospitals[i].name);
            require (keccak256(temp)!= keccak256(nameHosp));
        }
        _;
    }
    
    modifier noUnderZero (string memory blood, uint amount){
        require (hosp.availability[blood] >= amount); _;
    }

    function collect(Donor memory _don, uint _ml) public{
         hosp.availability [_don.blood] += _ml;
         _don.token += 1;
         donations.push (Donation(now, _don, hosp));
        // donations.push (Donation(now, _don));
    }
    
    function dispense (string memory blood, uint ml) public noUnderZero (blood, ml){
        hosp.availability [blood] -= ml;
    }
    
}

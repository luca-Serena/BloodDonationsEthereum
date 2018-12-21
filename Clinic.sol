pragma solidity >=0.4.22 <0.6.0;
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

    function findDonor (address _name) view private returns(uint){
        for (uint i=0; i < donors.length; i++){
            if (_name == donors[i].donorAddress){
                return i;
            }
        }
        return 1001 ;
    }

    function collect(address addr, uint _ml) public{
        uint index = findDonor (addr);
       if (index > 1000) return;
        Donor memory don = donors [index];
         hosp.availability [don.blood] += _ml;
         don.token += 1;
         donations.push (Donation(now, don, hosp));
        // donations.push (Donation(now, _don));
    }
    
    function dispense (string memory blood, uint ml) public noUnderZero (blood, ml){
        hosp.availability [blood] -= ml;
    }
    
}

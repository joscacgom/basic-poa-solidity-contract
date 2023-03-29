// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;


contract PoABaseContract {

    address public owner;
    
    struct Validator{
        address owner;
        uint lastTimeActive;
        bool isValid;
    }
    struct Tx{
        address[] signers;
        uint timestamps;
        string payload;
    }

    Validator[] validators;
    Tx[] transactions;

    uint8 public MAX_NUMBER_NODES;
    uint256 public MAX_NUMBER_INACTIVE_DAYS;
    uint256 public MIN_VALIDATIONS;


    // MODIFIERS

    modifier onlyOwner{
        require(msg.sender==owner,"Only owner can execute this function");
        _;
    }

    modifier onlyValidator{
        uint index;
        for (uint i = 0; i < validators.length; i++) {
            if (validators[i].owner == msg.sender) {
                index = i;
                break;
            }
        require(index < validators.length, "Only validators can execute this function");
            _;
    }
}

    // EVENTS

    event newValidatorAdded (address indexed validator);
    event validatorRemoved (address indexed validator);
    event newTxAdded (uint indexed transactionIndex);
    event txValidated (uint indexed transactionIndex);
    event txVoted (uint indexed transactionIndex,address indexed validator);
    event validatorStatusUpdated (address indexed validator,bool indexed isValid);

    // CONSTRUCTOR

    constructor(uint256 _minValidations,uint8 _maxNumberNodes,uint256 _maxNumberInactiveDays) {
        owner=msg.sender;
        MAX_NUMBER_NODES=_maxNumberNodes;
        MIN_VALIDATIONS=_minValidations;
        MAX_NUMBER_INACTIVE_DAYS=_maxNumberInactiveDays;
    }

    // PUBLIC FUNCTIONS

    function addValidator(address _validator) public onlyOwner {
        require(validators.length < MAX_NUMBER_NODES,"Maximum number of validators reached");

        Validator memory newValidator = Validator ({
            owner: _validator,
            lastTimeActive: block.timestamp,
            isValid: true
        });

        validators.push(newValidator);

        emit newValidatorAdded(_validator);
    }

    function removeValidator(address _validator) public onlyOwner {

        uint indexToDelete;
        for (uint i = 0; i < validators.length; i++) {
            if (validators[i].owner == _validator) {
                indexToDelete = i;
                break;
            }
        }

        require(indexToDelete < validators.length, "Validator not found");

        validators[indexToDelete] = validators[validators.length - 1];
        validators.pop();

        emit validatorRemoved(_validator);
    }

    function updateValidatorStatus(address _validator,bool _isValid ) public onlyOwner{
        
        for (uint i = 0; i < validators.length; i++) {
            if (validators[i].owner == _validator) {
                validators[i].isValid=_isValid;
                break;
            }
    }
        emit validatorStatusUpdated(_validator,_isValid);
}

    function voteTx(uint _transactionIndex) public onlyValidator{
        bool isValid = false;
        bool alreadyVoted = false;
        uint256 validatorIndex;
        for (uint i = 0; i < validators.length; i++) {
            if (validators[i].owner == msg.sender) {
                isValid=validators[i].isValid;
                validatorIndex=i;
                 break;
            }
        }

        for(uint i=0;i<transactions[_transactionIndex].signers.length;i++){
            if(transactions[_transactionIndex].signers[i]==msg.sender){
                alreadyVoted=true;
                break;
            }
        }

            require(isValid , "Validator is not a valid one");
            require(transactions[_transactionIndex].signers.length<=MIN_VALIDATIONS,"Tx is already validated!");
            require(block.timestamp - validators[validatorIndex].lastTimeActive <= MAX_NUMBER_INACTIVE_DAYS, "Validator is inactive");
            require(!alreadyVoted,"Validator already voted");
            
            validators[validatorIndex].lastTimeActive=block.timestamp;
            transactions[_transactionIndex].signers.push(msg.sender);
            _checkValidations(_transactionIndex);
            emit txVoted(_transactionIndex,msg.sender);
           
    }

    function addTx(string memory _payload) public {
        Tx memory newTx = Tx ({
            signers: new address[](0),
            timestamps: block.timestamp,
            payload: _payload
        });

        transactions.push(newTx);
        emit newTxAdded(transactions.length-1);
    }

    function getTx(uint _transactionIndex) public view returns (address[] memory signers,uint256 timestamps,string memory payload){
        return (transactions[_transactionIndex].signers,transactions[_transactionIndex].timestamps,transactions[_transactionIndex].payload);
    }

    function getTxCount() public view returns (uint){
        return transactions.length;
    }

    function getValidatorCount() public view returns (uint){
        return validators.length;
    }

    function getValidators() public view returns (Validator[] memory){
        return validators;
    }

    // INTERNAL FUNCTIONS

    function _checkValidations(uint _transactionIndex) internal {
        if(transactions[_transactionIndex].signers.length==MIN_VALIDATIONS){
            emit txValidated(_transactionIndex);
        }
    }


}

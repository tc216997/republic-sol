pragma solidity ^0.4.21;

import "./DarkNodeRegistry.sol";

contract Hyperdrive {

    struct Tx {
        bytes32[] nonces;
    }

    mapping(bytes32 => bool) nonces;

    DarkNodeRegistry darknodeRegistry;

    modifier onlyDarknode(address sender) {
        require(darknodeRegistry.isRegistered(bytes20(sender)));
        _;
    } 

    function Hyperdrive() public {
    }

    function sendTx(Tx transaction) public onlyDarknode(msg.sender) {
        for (uint256 i = 0; i < transaction.nonces.length; i++) {
            require(!nonces[transaction.nonces[i]]);
        }
        for (uint256 i = 0; i < transaction.nonces.length; i++) {
            nonces[transaction.nonces[i]] = true;
        }
    }

}
pragma solidity ^0.4.21;

import "./DarkNodeRegistry.sol";

contract Hyperdrive {

    mapping(bytes32 => bool) nonces;

    DarkNodeRegistry darknodeRegistry;

    modifier onlyDarknode(address sender) {
        require(darknodeRegistry.isRegistered(bytes20(sender)));
        _;
    } 

    function Hyperdrive(address dnr) public {
        darknodeRegistry = DarkNodeRegistry(dnr);
    }

    function sendTx(bytes32[] tx) public onlyDarknode(msg.sender) {
        for (uint256 i = 0; i < tx.length; i++) {
            require(!nonces[tx[i]]);
        }
        for (i = 0; i < tx.length; i++) {
            nonces[tx[i]] = true;
        }
    }
}
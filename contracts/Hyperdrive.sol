pragma solidity ^0.4.21;

import "./DarkNodeRegistry.sol";

contract Hyperdrive {

    event Tx(bytes32 nonce);

    mapping(bytes32 => uint256) public nonces;

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
            nonces[tx[i]] = block.number;
            emit Tx(tx[i]);
        }
    }

    function depth(bytes32 nonce) public view returns(uint256) {
        if (nonces[nonce] == 0) {
            return 0;
        }
        return (block.number - nonces[nonce]);
    }
}
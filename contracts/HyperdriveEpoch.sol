pragma solidity ^0.4.19;

import "./libraries/LinkedList.sol";

/**
 * @notice HyperdriveEpoch is used by the Hyperdrive to elect new commanders.
 */
contract HyperdriveEpoch {

    struct Epoch {
        uint256 blockhash;
        uint256 timestamp;
    }

    // The current epoch and the minimum time interval until the next epoch.
    Epoch public currentEpoch;
    uint256 public minimumEpochInterval;

    /**
    * @notice Emitted when a new epoch has begun
    */
    event NewEpoch();

    /** 
    * @notice The DarkNodeRegistry constructor.
    *
    * @param _minimumEpochInterval The minimum amount of time between epochs.
    */
    function HyperdriveEpoch(uint256 _minimumEpochInterval) public {
        minimumEpochInterval = _minimumEpochInterval;
        currentEpoch = Epoch({
            blockhash: uint256(block.blockhash(block.number - 1)),
            timestamp: now
        });
    }

    /**
    * @notice Progress the epoch if it is possible and necessary to do so. This
    * captures the current timestamp and current blockhash and overrides the
    * current epoch.
    */
    function epoch() public {
        require(now > currentEpoch.timestamp + minimumEpochInterval);

        uint256 blockhash = uint256(block.blockhash(block.number - 1));

        // Update the epoch hash and timestamp
        currentEpoch = Epoch({
            blockhash: blockhash,
            timestamp: currentEpoch.timestamp + minimumEpochInterval
        });

        // Emit an event
        emit NewEpoch();
    }

}

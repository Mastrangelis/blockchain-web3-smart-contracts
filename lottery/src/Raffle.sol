// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";

/**
 * @title A sample Raffle contract
 * @author Nikos Mastrangelis
 * @notice This contract is for creating sample raffle
 * @dev Implements Chainlink VRFv2.5
 */
contract Raffle is VRFConsumerBaseV2Plus {
    error Raffle__SendMoreToSendRaffle();
    error Raffle__TransferFailed();
    error Raffle_RaffleNotOpen();
    error Raffle__UpkeepNotNeeded(
        uint256 balance,
        uint256 players,
        uint256 state
    );

    enum RaffleState {
        OPEN,
        CALCULATING_WINNER
    }

    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    uint256 private immutable i_entranceFee;
    // @dev the interval in seconds that the raffle will run
    uint256 private immutable i_interval;
    bytes32 private immutable i_keyhash;
    uint256 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;

    address payable[] private s_players;
    uint256 private s_lastTimestamp;
    address private s_recentWinner;

    RaffleState private s_raffleState;

    event RaffleEntered(address indexed player);
    event RaffleWinner(address indexed winner);

    constructor(
        uint256 _entranceFee,
        uint256 _interval,
        address _vrfCoordinator,
        bytes32 _keyhash,
        uint256 _subscriptionId,
        uint32 _callbackGasLimit
    ) VRFConsumerBaseV2Plus(_vrfCoordinator) {
        i_entranceFee = _entranceFee;
        i_interval = _interval;
        i_keyhash = _keyhash;
        i_subscriptionId = _subscriptionId;
        i_callbackGasLimit = _callbackGasLimit;
        s_lastTimestamp = block.timestamp;

        s_raffleState = RaffleState.OPEN;
    }

    function enterRaffle() external payable {
        // require(msg.value >= i_entranceFee, "You must pay the entrance fee");

        // require(msg.value >= i_entranceFee, Raffle__SendMoreToSendRaffle());

        if (s_raffleState != RaffleState.OPEN) {
            revert();
        }

        if (msg.value < i_entranceFee) {
            revert Raffle__SendMoreToSendRaffle();
        }

        s_players.push(payable(msg.sender));

        /**
         * As a rule of thumb, anytime we update a storage variable
         * we should emit an event to notify the frontend
         */
        emit RaffleEntered(msg.sender);
    }

    function performUpkeep(bytes calldata /* performData */) external {
        (bool upkeepNeeded, ) = checkUpkeep("");

        if (!upkeepNeeded) {
            revert Raffle__UpkeepNotNeeded(
                address(this).balance,
                s_players.length,
                uint256(s_raffleState)
            );
        }

        s_raffleState = RaffleState.CALCULATING_WINNER;

        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient
            .RandomWordsRequest({
                keyHash: i_keyhash,
                subId: i_subscriptionId,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: i_callbackGasLimit,
                numWords: NUM_WORDS,
                // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            });

        uint256 requestId = s_vrfCoordinator.requestRandomWords(request);
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] calldata randomWords
    ) internal override {
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[indexOfWinner];
        s_recentWinner = recentWinner;
        s_raffleState = RaffleState.OPEN;
        s_players = new address payable[](0);
        s_lastTimestamp = block.timestamp;
        emit RaffleWinner(recentWinner);

        (bool success, ) = recentWinner.call{value: address(this).balance}("");

        if (!success) {
            revert Raffle__TransferFailed();
        }
    }

    /**
     * @dev This is the function that chainlink nodes will call to check if the lottery is ready
     * to pick a winner. The following should be tree in order for the upkeepNeeded needed to be run
     * 1. The time interval has passed between raffle runs
     * 2. The raffle is in the OPEN state
     * 3. The raffle has players
     * @param - ignored
     * @return upkeepNeeded  - true if it's time to restart the raffle
     * @return - ignored
     */
    function checkUpkeep(
        bytes memory /* checkData */
    ) public view returns (bool upkeepNeeded, bytes memory /* performData */) {
        bool timeHasPassed = (block.timestamp - s_lastTimestamp) > i_interval;
        bool isOpen = s_raffleState == RaffleState.OPEN;
        bool hasBalance = address(this).balance > 0;
        bool hasPlayers = s_players.length > 0;

        upkeepNeeded = timeHasPassed && isOpen && hasBalance && hasPlayers;

        return (upkeepNeeded, "");
    }

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}

/**
 * View functions are read-only functions that do not modify the state of the contract.
 * Pure functions are like void, they don't read or modify the state of the contract.
 */

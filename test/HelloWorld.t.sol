// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.22;

import {Test} from "forge-std/Test.sol";
import {IERC20} from "hyperdrive/contracts/src/interfaces/IERC20.sol";
import {IHyperdrive} from "hyperdrive/contracts/src/interfaces/IHyperdrive.sol";
import {HelloWorld} from "../src/HelloWorld.sol";

contract HelloWorldTest is Test {
    /// @dev The block at which to create the mainnet fork.
    uint256 internal constant FORK_BLOCK = 20_967_387;

    /// @dev The mainnet RPC URL. This is looked up from an environment variable.
    string internal MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    address internal constant DAI_WHALE =
        0xD1668fB5F690C59Ab4B0CAbAd0f8C1617895052B;

    /// @dev The sDAI Hyperdrive instance on mainnet.
    IHyperdrive internal constant SDAI_HYPERDRIVE =
        IHyperdrive(0x324395D5d835F84a02A75Aa26814f6fD22F25698);

    /// @dev The HelloWorld contract.
    HelloWorld internal helloWorld;

    /// @notice Creates a mainnet fork, impersonates a DAI whale account, and
    ///         prepares to open a long on the sDAI pool.
    function setUp() external {
        // Create a mainnet fork.
        uint256 mainnetForkId = vm.createFork(MAINNET_RPC_URL);
        vm.selectFork(mainnetForkId);
        vm.rollFork(FORK_BLOCK);

        // Deploy the HelloWorld contract.
        helloWorld = new HelloWorld(SDAI_HYPERDRIVE);

        // Impersonate the DAI whale and approve the HelloWorld contract.
        vm.stopPrank();
        vm.startPrank(DAI_WHALE);
        IERC20(SDAI_HYPERDRIVE.baseToken()).approve(
            address(helloWorld),
            type(uint256).max
        );
    }

    /// @notice Calls `helloWorld`.
    function testHelloWorld() external {
        helloWorld.helloWorld();
    }
}

// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {PrimeNFT} from "../src/PrimeNFT.sol";

contract PrimeNFTTest is Test {
    PrimeNFT primeNFT;

    address bob;
    address alice;
    uint256 bobsTokenId;

    function setUp() public {
        primeNFT = new PrimeNFT();

        bob = makeAddr("bob");
        alice = makeAddr("alice");
    }

    function testMint() public {
        uint256 tokenId1 = primeNFT.mint(address(bob));
        uint256 tokenId2 = primeNFT.mint(address(bob));
        uint256 tokenId3 = primeNFT.mint(address(bob));
        uint256 tokenId4 = primeNFT.mint(address(bob));
        uint256 tokenId5 = primeNFT.mint(address(bob));

        vm.prank(bob);
        uint256 primeCount = primeNFT.getPrimeCount();

        assertEq(primeCount, 3);
    }

    function testTwoPersona() public {
        //mint for bob
        uint256 tokenId1 = primeNFT.mint(address(bob));
        uint256 tokenId2 = primeNFT.mint(address(bob));

        // mint for alice
        uint256 tokenId3 = primeNFT.mint(address(alice));
        uint256 tokenId4 = primeNFT.mint(address(alice));
        uint256 tokenId5 = primeNFT.mint(address(alice));

        vm.prank(bob);
        uint256 primeCountBob = primeNFT.getPrimeCount();

        vm.prank(alice);
        uint256 primeCountAlice = primeNFT.getPrimeCount();

        assertEq(primeCountBob, 1);
        assertEq(primeCountAlice, 2);
    }

    function testHundredPrime() public {
        uint length = 100;
        for (uint i = 0; i < length; i++) {
            primeNFT.mint(address(bob));
        }
        vm.prank(bob);
        uint256 primeCountBob = primeNFT.getPrimeCount();
        assertEq(primeCountBob, 25);
    }
}

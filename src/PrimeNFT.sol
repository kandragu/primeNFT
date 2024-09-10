// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract PrimeNFT is ERC721Enumerable {
    uint256 public tokenCounter;
    uint8 constant MAX_SUPPLY = 100;

    constructor() ERC721("Prime", "PP") {}

    function mint(address _to) external returns (uint256) {
        require(tokenCounter < MAX_SUPPLY, "Max token supply minted already");
        tokenCounter++;
        uint256 tokenId = tokenCounter;
        _mint(_to, tokenId);
        return tokenId;
    }

    // Implement supportsInterface function to signal supported interfaces
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override returns (bool) {
        return
            interfaceId == type(ERC721Enumerable).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    // Get all token IDs owned by a particular address
    function tokensOfOwner(
        address owner
    ) private view returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(owner); // Get the number of tokens owned by the user
        uint256[] memory tokenIds = new uint256[](tokenCount);

        for (uint256 i = 0; i < tokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(owner, i); // Get token ID by index
        }

        return tokenIds;
    }

    function getPrimeCount() external view returns (uint256) {
        uint256[] memory tokenIds = tokensOfOwner(msg.sender);

        return findAllPrimes(tokenIds);
    }

    function findAllPrimes(
        uint256[] memory tokenIds
    ) private pure returns (uint256 count) {
        uint256 length = tokenIds.length;

        for (uint256 i = 0; i < length; i++) {
            if (isPrime(tokenIds[i])) {
                count++;
            }
        }
    }

    function isPrime(uint256 n) public pure returns (bool) {
        if (n <= 1) return false;
        if (n <= 3) return true;
        if (n % 2 == 0 || n % 3 == 0) return false;

        for (uint256 i = 5; i * i <= n; i += 6) {
            if (n % i == 0 || n % (i + 2) == 0) return false;
        }

        return true;
    }
}
